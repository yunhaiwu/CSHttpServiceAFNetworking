//
//  CSServicesContainer.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSServicesContainer.h"
#import "CSServiceWrapper.h"
#import "CSServiceRegisterDefine.h"
#import "CSSafeDictionary.h"
#import "CSServiceContext.h"
#import <WJLoggingAPI/WJLoggingAPI.h>
#import "NSObject+CSService.h"
#import "CSApplicationPreloadDataManager.h"

@interface CSServicesContainer ()

@property (nonatomic, strong) CSSafeDictionary<NSString*, CSServiceWrapper*> *serviceIdToServiceWrapper;

@property (nonatomic, strong) CSSafeDictionary<NSString*, CSServiceContext*> *protocolToServiceContext;

@property (nonatomic, strong) CSSafeDictionary<NSString*, CSSafeDictionary<NSString *, CSSafeSet<NSString*>*>*> *moduleIdToServiceIds;

@end

@implementation CSServicesContainer

- (instancetype)init {
    self = [super init];
    if (self) {
        WJLogDebug(@"✅ service container initialize ......");
        self.serviceIdToServiceWrapper = [[CSSafeDictionary alloc] init];
        self.protocolToServiceContext = [[CSSafeDictionary alloc] init];
        self.moduleIdToServiceIds = [[CSSafeDictionary alloc] init];
    }
    return self;
}

- (void)remvoeServicesByModuleId:(NSString*)moduleId {
    CSSafeDictionary<NSString *, CSSafeSet<NSString*>*>* protocolToServiceIds = [self.moduleIdToServiceIds objectForKey:moduleId];
    NSArray *protocols = [protocolToServiceIds allKeys];
    for (NSString *protocolName in protocols) {
        NSSet<NSString*> *removeServiceIdSet = [[protocolToServiceIds objectForKey:protocolName] origDataCopy];
        CSServiceContext *serviceContext = [self.protocolToServiceContext objectForKey:protocolName];
        [serviceContext.serviceIdSet minusSet:removeServiceIdSet];
        if ([serviceContext.serviceIdSet count] == 0) {
            [self.protocolToServiceContext removeObjectForKey:protocolName];
        } else {
            if ([removeServiceIdSet containsObject:serviceContext.defaultServiceWrapper.getServiceId]) {
                CSServiceWrapper *wrapper = [self.serviceIdToServiceWrapper objectForKey:[serviceContext.serviceIdSet anyObject]];
                serviceContext.defaultServiceWrapper = wrapper;
            }
        }
        for (NSString *serviceId in removeServiceIdSet) {
            CSServiceWrapper *wrapper = [self.serviceIdToServiceWrapper objectForKey:serviceId];
            [wrapper removeReferenceProtocol:protocolName];
            if (![wrapper hasProtocolReferences]) {
                [self.serviceIdToServiceWrapper removeObjectForKey:serviceId];
            }
        }
    }
    WJLogDebug(@"✅ unregister service successful by moduleId '%@'", moduleId);
}

- (id)fetchService:(Protocol*)protocol serviceId:(NSString*)serviceId {
    id service = nil;
    CSServiceContext *context = [self.protocolToServiceContext objectForKey:NSStringFromProtocol(protocol)];
    if (serviceId) {
        if ([[context serviceIdSet] containsObject:serviceId]) {
            CSServiceWrapper *wrapper = [self.serviceIdToServiceWrapper objectForKey:serviceId];
            service = [wrapper getServiceObject];
        }
    } else {
        service = [[context defaultServiceWrapper] getServiceObject];
    }
    return service;
}

- (id)fetchService:(Protocol*)protocol {
    return [self fetchService:protocol serviceId:nil];
}

- (NSArray*)fetchServices:(Protocol*)protocol {
    NSMutableArray *result = nil;
    CSServiceContext *context = [self.protocolToServiceContext objectForKey:NSStringFromProtocol(protocol)];
    NSArray<CSServiceWrapper*> *wrappers = [self.serviceIdToServiceWrapper objectsForKeys:[[context serviceIdSet] allObjects]];
    if ([wrappers count]) {
        result = [[NSMutableArray alloc] initWithCapacity:[wrappers count]];
        for (CSServiceWrapper *wrapper in wrappers) {
            id service = [wrapper getServiceObject];
            if (service) [result addObject:service];
        }
    }
    return [result copy];
}

- (Class)fetchServiceClass:(Protocol*)protocol {
    CSServiceContext *context = [self.protocolToServiceContext objectForKey:NSStringFromProtocol(protocol)];
    return [[context defaultServiceWrapper] getServiceClass];
}

- (NSArray<Class>*)fetchServiceClassList:(Protocol*)protocol {
    NSMutableArray *result = nil;
    CSServiceContext *context = [self.protocolToServiceContext objectForKey:NSStringFromProtocol(protocol)];
    NSArray<CSServiceWrapper*> *wrappers = [self.serviceIdToServiceWrapper objectsForKeys:[[context serviceIdSet] allObjects]];
    if ([wrappers count]) {
        result = [[NSMutableArray alloc] initWithCapacity:[wrappers count]];
        for (CSServiceWrapper *wrapper in wrappers) {
            [result addObject:[wrapper getServiceClass]];
        }
    }
    return [result copy];
}

- (void)batchRegisterServices:(NSSet<id<CSServiceRegisterDefine>>*)defines {
    NSEnumerator *enumerator = [defines objectEnumerator];
    id<CSServiceRegisterDefine> define = nil;
    while (define = [enumerator nextObject]) {
        [self registerService:define];
    }
}

- (void)registerService:(id<CSServiceRegisterDefine>)define {
    Protocol *protocol = [define serviceProtocol];
    NSString *protocolName = NSStringFromProtocol(protocol);
    NSSet<Class> *serviceClassSet = [define serviceClassSet];
    NSEnumerator *enumerator = [serviceClassSet objectEnumerator];
    Class serviceClass = Nil;
    while (serviceClass = [enumerator nextObject]) {
        if ([serviceClass conformsToProtocol:protocol]) {
            NSString *serviceId = [serviceClass serviceId];
            CSServiceWrapper *wrapper = [self.serviceIdToServiceWrapper objectForKey:serviceId];
            if (!wrapper) {
                wrapper = [[CSServiceWrapper alloc] initWithServiceClass:serviceClass];
                [self.serviceIdToServiceWrapper setObject:wrapper forKey:serviceId];
            }
            if ([wrapper addReferenceProtocol:protocolName]) {
                CSServiceContext *context = [self.protocolToServiceContext objectForKey:protocolName];
                if (!context) {
                    context = [[CSServiceContext alloc] initWithServiceWrapper:wrapper];
                    [self.protocolToServiceContext setObject:context forKey:protocolName];
                }
                [context addServiceId:serviceId];
                
                NSString *moduleId = [serviceClass belongModuleId];
                CSSafeDictionary<NSString*, CSSafeSet<NSString*>*> *modServiceIds = [self.moduleIdToServiceIds objectForKey:moduleId];
                if (!modServiceIds) {
                    modServiceIds = [[CSSafeDictionary alloc] init];
                    [self.moduleIdToServiceIds setObject:modServiceIds forKey:moduleId];
                }
                CSSafeSet<NSString*> *serviceIds = [modServiceIds objectForKey:protocolName];
                if (!serviceIds) {
                    serviceIds = [[CSSafeSet alloc] init];
                    [modServiceIds setObject:serviceIds forKey:protocolName];
                }
                [serviceIds addObject:serviceId];
                
                WJLogDebug(@"✅ register service successful '%@'->'%@'", protocolName, serviceId);
            }
        } else {
            WJLogDebug(@"❌ register service fail, class '%@' not implementation '%@' protocol", NSStringFromClass(serviceClass), protocolName);
        }
    }
}

#pragma mark CSApplicationPlugin
+ (id<CSApplicationPlugin>)sharedPlugin {
    return [CSServicesContainer new];
}

- (void)applicationContext:(id<CSApplicationContext>)applicationContext moduleWillLoad:(id<CSModuleContext>)moduleContext {
    NSString *moduleId = [moduleContext moduleId];
    NSSet<id<CSServiceRegisterDefine>>* serviceDefines = [[CSApplicationPreloadDataManager sharedInstance] getServiceRegisterDefineSet:moduleId];
    if ([serviceDefines count]) {
        [self batchRegisterServices:serviceDefines];
    }
}

- (void)applicationContext:(id<CSApplicationContext>)applicationContext moduleDidDestroy:(id<CSModuleContext>)moduleContext {
    NSString *moduleId = [moduleContext moduleId];
    [self remvoeServicesByModuleId:moduleId];
}

@end
