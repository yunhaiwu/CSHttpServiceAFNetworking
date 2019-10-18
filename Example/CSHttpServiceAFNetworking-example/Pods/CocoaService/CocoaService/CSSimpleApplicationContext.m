//
//  CSSimpleApplicationContext.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSSimpleApplicationContext.h"
#import <WJLoggingAPI/WJLoggingAPI.h>
#import "CSModule.h"
#import "CSModuleContainer.h"
#import "CSServicesContainer.h"
#import "CSApplicationPreloadDataManager.h"
#import "CSSimpleModuleRegisterDefine.h"
#import "CSSimpleServiceRegisterDefine.h"
#import "CSAppGlobalDefaultModule.h"
#import "CSTaskScheduler.h"
#import "CSAppGlobalDefaultModule.h"
#import "CSSafeArray.h"
#import "CSModuleAppDelegateListener.h"
#import "CSMonitorContext.h"
#import "CSModuleContext.h"
#import "CSAspectContainer.h"
#import "CSSimpleAspectRegisterDefine.h"

@interface CSSimpleApplicationContext ()<CSModuleContainerDelegate>

@property (nonatomic, strong) CSModuleContainer *moduleContainer;

@property (nonatomic, strong) CSServicesContainer *serviceContainer;

@property (nonatomic, strong) CSAspectContainer *aspectContainer;

@property (nonatomic, strong) CSSafeArray<id<CSModuleAppDelegateListener>> *appDelegateListeners;

@end

@implementation CSSimpleApplicationContext

- (void)loadApplicationGlobalModule {
    [self.moduleContainer registerModule:[[CSApplicationPreloadDataManager sharedInstance] generateModuleRegisterDefine:[CSAppGlobalDefaultModule class]]];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[[CSMonitorContext sharedInstance] timeProfiler] beginAppLaunched];
        self.appDelegateListeners = [[CSSafeArray alloc] init];
        self.serviceContainer = [[CSServicesContainer alloc] init];
        self.aspectContainer = [[CSAspectContainer alloc] init];
        self.moduleContainer = [[CSModuleContainer alloc] initWithApplicationContext:self delegate:self];
        [self performModulesRegister];
    }
    return self;
}

/**
 触发模块加载
 */
-(void)performModulesRegister {
    [self loadApplicationGlobalModule];
    NSSet<id<CSModuleRegisterDefine>> *modDefineSet = [[CSApplicationPreloadDataManager sharedInstance] getModuleRegisterDefineSet];
    for (id<CSModuleRegisterDefine> modDefine in modDefineSet) {
        [self.moduleContainer registerModule:modDefine];
    }
}

#pragma mark forwarding lifecycle method
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSArray<id<CSModuleAppDelegateListener>> *listeners = [self.appDelegateListeners origDataCopy];
    for (NSInteger i = 0; i < [listeners count]; i++) {
        id<CSModuleAppDelegateListener> listener = listeners[i];
        if ([listener respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:listener];
        }
    }
}

#pragma mark CSModuleContainerDelegate
- (void)moduleContainer:(CSModuleContainer *)modContainer unRegisterAppDelegateListener:(id<CSModuleAppDelegateListener>)listener {
    [self.appDelegateListeners removeObject:listener];
}

- (void)moduleContainer:(CSModuleContainer *)modContainer registerAppDelegateListener:(id<CSModuleAppDelegateListener>)listener {
    [self.appDelegateListeners addObject:listener];
}

- (void)moduleContainer:(CSModuleContainer *)modContainer willLoadModule:(id<CSModuleContext>)moduleContext {
    NSString *moduleId = [moduleContext moduleId];
    NSSet<id<CSServiceRegisterDefine>>* serviceDefines = [[CSApplicationPreloadDataManager sharedInstance] getServiceRegisterDefineSet:moduleId];
    if ([serviceDefines count]) {
        [self.serviceContainer batchRegisterServices:serviceDefines];
    }
    
    NSSet<id<CSAspectRegisterDefine>>* aspectDefines = [[CSApplicationPreloadDataManager sharedInstance] getAspectRegisterDefineSet:moduleId];
    if ([aspectDefines count]) {
        [self.aspectContainer batchRegisterAspects:aspectDefines];
    }
    
}

- (void)moduleContainer:(CSModuleContainer *)modContainer didDestroyModule:(id<CSModuleContext>)moduleContext {
    NSString *moduleId = [moduleContext moduleId];
    [self.aspectContainer removeAspectsByModuleId:moduleId];
    [self.serviceContainer remvoeServicesByModuleId:moduleId];
}

#pragma mark CSApplicationContext
- (void)batchRegisterServices:(NSSet<id<CSServiceRegisterDefine>>*)serviceDefines {
    [self.serviceContainer batchRegisterServices:serviceDefines];
}

- (void)registerService:(id<CSServiceRegisterDefine>)serviceDefine {
    [self.serviceContainer registerService:serviceDefine];
}

- (void)registerService:(Protocol*)protocol serviceClass:(Class)serviceClass {
    id<CSServiceRegisterDefine> define = [CSSimpleServiceRegisterDefine buildDefine:protocol serviceClass:serviceClass];
    if (define) {
        [self.serviceContainer registerService:define];
    }
}

- (id)fetchService:(Protocol*)protocol serviceId:(NSString*)serviceId {
    return [_aspectContainer fetchServiceProxy:[self.serviceContainer fetchService:protocol serviceId:serviceId]];
}

- (id)fetchService:(Protocol*)protocol {
    return [_aspectContainer fetchServiceProxy:[self.serviceContainer fetchService:protocol]];
}

- (NSArray*)fetchServiceList:(Protocol*)protocol {
    NSArray *services = [self.serviceContainer fetchServices:protocol];
    if ([services count]) {
        NSMutableArray *serviceProxys = [[NSMutableArray alloc] initWithCapacity:[services count]];
        for (id service in services) {
            [serviceProxys addObject:[_aspectContainer fetchServiceProxy:service]];
        }
        services = [serviceProxys copy];
    }
    return services;
}

- (Class)fetchServiceClass:(Protocol*)protocol {
    return [self.serviceContainer fetchServiceClass:protocol];
}

- (NSArray<Class>*)fetchServiceClassList:(Protocol*)protocol {
    return [self.serviceContainer fetchServiceClassList:protocol];
}

- (void)registerModule:(Class)modClass {
    id<CSModuleRegisterDefine> define = [[CSApplicationPreloadDataManager sharedInstance] generateModuleRegisterDefine:modClass];
    if (define) {
        [self.moduleContainer registerModule:define];
    }
}

- (void)unRegisterModule:(Class)modClass {
    [self.moduleContainer unRegisterModule:modClass];
}

- (id)fetchServiceProxy:(id)targetService {
    return [_aspectContainer fetchServiceProxy:targetService];
}

- (void)registerAspect:(Class)aspectClass {
    CSSimpleAspectRegisterDefine *define = [CSSimpleAspectRegisterDefine buildDefine:aspectClass];
    if (define) {
        [self.aspectContainer registerAspect:define];
    }
}

- (void)batchRegisterAspects:(NSSet<id<CSAspectRegisterDefine>>*)aspects {
    [self.aspectContainer batchRegisterAspects:aspects];
}

@end
