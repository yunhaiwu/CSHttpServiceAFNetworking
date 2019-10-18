//
//  CSServiceWrapper.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSServiceWrapper.h"
#import "NSObject+CSService.h"
#import "CSSafeSet.h"
#import <WJLoggingAPI/WJLoggingAPI.h>

@interface CSServiceWrapper ()

/**
 service对应服务协议集合
 */
@property (nonatomic, strong) CSSafeSet<NSString*> *referenceProtocolSet;

/**
 服务类型
 */
@property (nonatomic, assign) Class serviceClass;

/**
 单利实例对象
 */
@property (atomic, strong) id singletonServiceObject;


/**
 hasSingleton：是否为单利
 hasSharedInstance：是否实现了方法sharedInstance
 hasCustomInstance：是否实现了方法customInstance
 */
@property (nonatomic, assign) BOOL hasSingleton, hasSharedInstance, hasCustomInstance;

@end

@implementation CSServiceWrapper

- (instancetype)initWithServiceClass:(Class)class {
    if (self = [super init]) {
        NSAssert(class != Nil, @"❌ initServiceWrapper: serviceClass cannot be Nil");
        self.serviceClass = class;
        self.referenceProtocolSet = [[CSSafeSet alloc] init];
        if ([self.serviceClass respondsToSelector:@selector(hasSingleton)]) {
            _hasSingleton = [self.serviceClass hasSingleton];
        }
        _hasSharedInstance = [self.serviceClass respondsToSelector:@selector(sharedInstance)];
        _hasCustomInstance = [self.serviceClass respondsToSelector:@selector(customInstance)];
    }
    return self;
}

- (BOOL)addReferenceProtocol:(NSString*)protocolName {
    if ([self.referenceProtocolSet containsObject:protocolName]) {
        return NO;
    }
    [self.referenceProtocolSet addObject:protocolName];
    return YES;
}

- (void)removeReferenceProtocol:(NSString*)protocolName {
    [self.referenceProtocolSet removeObject:protocolName];
}

- (BOOL)hasProtocolReferences {
    return [self.referenceProtocolSet count];
}

- (id)getServiceObject {
    id serviceObject = self.singletonServiceObject;
    if (!serviceObject) {
        @try {
            if (_hasSingleton) {
                @synchronized (self) {
                    if (!_singletonServiceObject) {
                        self.singletonServiceObject = [self getSharedInstance];
                    }
                    if (!self.singletonServiceObject) {
                        self.singletonServiceObject = [self getCustomInstance];
                    }
                    if (!self.singletonServiceObject) {
                        serviceObject = [[self.serviceClass alloc] init];
                    }
                    serviceObject = self.singletonServiceObject;
                }
            } else {
                serviceObject = [self getCustomInstance];
                if (!serviceObject) {
                    serviceObject = [[self.serviceClass alloc] init];
                }
            }
        } @catch (NSException *exception) {
            WJLogError(@"❌ getServiceObject error: %@", exception);
        }
    }
    return serviceObject;
}

- (id)getSharedInstance {
    if (_hasSharedInstance) {
        return [self.serviceClass sharedInstance];
    }
    return nil;
}

- (id)getCustomInstance {
    if (_hasCustomInstance) {
        return [self.serviceClass customInstance];
    }
    return nil;
}

- (NSString *)getServiceId {
    return [_serviceClass serviceId];
}

- (NSString *)getBelongModuleId {
    return [_serviceClass belongModuleId];
}

- (Class)getServiceClass {
    return _serviceClass;
}

@end
