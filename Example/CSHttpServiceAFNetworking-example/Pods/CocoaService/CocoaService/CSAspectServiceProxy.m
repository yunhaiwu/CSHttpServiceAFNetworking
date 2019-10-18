//
//  CSAspectServiceProxy.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSAspectServiceProxy.h"
#import "CSSimpleAspectJoinPoint.h"

@interface CSAspectServiceProxy ()

@property (nonatomic, strong) NSObject *target;

@property (nonatomic, copy) NSDictionary<NSString*, NSSet<CSAspectContext*>*> *methodToAspects;

@property (nonatomic, copy) NSSet<CSAspectContext*> *generalAspects;

@end

@implementation CSAspectServiceProxy

+ (instancetype)instanceProxy:(id)target aspectFetcher:(NSDictionary<NSString*, NSSet<CSAspectContext*>*>*)methodToAspects {
    CSAspectServiceProxy *serviceProxy = [CSAspectServiceProxy alloc];
    [serviceProxy setTarget:target];
    [serviceProxy setMethodToAspects:methodToAspects];
    [serviceProxy setGeneralAspects:methodToAspects[@"*"]];
    return serviceProxy;
    
}

- (Class)class {
    if (_target) {
        return [_target class];
    }
    return [super class];
}

- (Class)superclass {
    if (_target) {
        return [_target superclass];
    }
    return [super class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *result = nil;
    if (self.target) {
        result = [self.target methodSignatureForSelector:sel];
    } else {
        result = [super methodSignatureForSelector:sel];
    }
    return result;
}

- (NSSet<CSAspectContext*>*)getAspectsBySelector:(SEL)selector {
    NSMutableSet<CSAspectContext*> *result = [[NSMutableSet alloc] init];
    NSSet<CSAspectContext*> *methodAspects = self.methodToAspects[NSStringFromSelector(selector)];
    if (methodAspects) {
        [result addObjectsFromArray:[methodAspects allObjects]];
    }
    if (self.generalAspects) {
        [result addObjectsFromArray:[self.generalAspects allObjects]];
    }
    return result;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL selector = [invocation selector];
    if ([self.target respondsToSelector:selector]) {
        @autoreleasepool {
            [invocation setTarget:self.target];
            NSSet<CSAspectContext*> *contextSet = [self getAspectsBySelector:invocation.selector];
            if ([contextSet count] > 0) {
                CSSimpleAspectJoinPoint *joinPoint = [[CSSimpleAspectJoinPoint alloc] initWithInvocation:invocation];
                for (CSAspectContext *context in contextSet) {
                    if ([context options] & CSAopAspectActionOptionBefore) {
                        [[context aspectObject] doBefore:joinPoint];
                    }
                }
                for (CSAspectContext *context in contextSet) {
                    if ([context options] & CSAopAspectActionOptionAround) {
                        [[context aspectObject] doAround:joinPoint];
                    }
                }
                if (![joinPoint isPerformed]) {
                    [invocation invoke];
                }
                for (CSAspectContext *context in contextSet) {
                    if ([context options] & CSAopAspectActionOptionAfter) {
                        [[context aspectObject] doAfter:joinPoint];
                    }
                }
            } else {
                [invocation invoke];
            }
        }
    }
}

- (BOOL)isProxy {
    return YES;
}

@end
