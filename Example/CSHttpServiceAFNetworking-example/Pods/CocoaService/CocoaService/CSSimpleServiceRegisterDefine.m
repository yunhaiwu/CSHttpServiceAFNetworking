//
//  CSSimpleServiceRegisterDefine.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSSimpleServiceRegisterDefine.h"
#import "NSObject+CSService.h"
#import <WJLoggingAPI/WJLoggingAPI.h>

@interface CSSimpleServiceRegisterDefine ()

//服务协议
@property (nonatomic, strong) Protocol *serviceProtocol;

//服务列表，所有元素Class都实现了protocol协议
@property(nonatomic, strong) NSMutableSet<Class> *serviceClassSet;

@end

@implementation CSSimpleServiceRegisterDefine

+ (instancetype)buildDefine:(Protocol*)protocol serviceClass:(Class)serviceClass {
    CSSimpleServiceRegisterDefine *define = nil;
    if ([serviceClass conformsToProtocol:protocol]) {
        define = [[CSSimpleServiceRegisterDefine alloc] initWithProtocol:protocol serviceClass:serviceClass];
    } else {
        WJLogError(@"❌ service build fail, class '%@' not implementation '%@' protocol", NSStringFromClass(serviceClass), NSStringFromProtocol(protocol));
    }
    return define;
}

- (instancetype)initWithProtocol:(Protocol *)serviceProtocol serviceClass:(Class)serviceClass {
    self = [super init];
    if (self) {
        self.serviceProtocol = serviceProtocol;
        self.serviceClassSet = [[NSMutableSet alloc] initWithObjects:serviceClass, nil];
    }
    return self;
}


- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        if ([self serviceProtocol] == [object serviceProtocol]) {
            return YES;
        }
    }
    return NO;
    
}

- (NSUInteger)hash {
    return [NSStringFromProtocol(_serviceProtocol) hash];
}

- (void)appendServiceClass:(Class)serviceClass {
    if (serviceClass) {
        [self.serviceClassSet addObject:serviceClass];
    }
}

#pragma mark CSServiceRegisterDefine
- (Protocol*)serviceProtocol {
    return _serviceProtocol;
}

- (NSSet<Class>*)serviceClassSet {
    return _serviceClassSet;
}

@end
