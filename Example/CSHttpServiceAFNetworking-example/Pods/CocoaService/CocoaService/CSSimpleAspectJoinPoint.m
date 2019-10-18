//
//  CSSimpleAspectJoinPoint.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSSimpleAspectJoinPoint.h"

@interface CSSimpleAspectJoinPoint ()

@property (nonatomic, strong) NSInvocation *invocation;

@property (atomic, assign) BOOL performed;

@end

@implementation CSSimpleAspectJoinPoint

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
    self = [super init];
    if (self) {
        self.invocation = invocation;
    }
    return self;
}

- (NSInvocation*)getInvocation {
    return _invocation;
}

#pragma mark CSAspectJoinPoint
- (SEL)aopSelector {
    return [_invocation selector];
}

- (id)aopTarget {
    return [_invocation target];
}

- (NSUInteger)numberOfArguments {
    return [[_invocation methodSignature] numberOfArguments];
}

- (void)getArgument:(void *)argumentLocation atIndex:(NSInteger)idx {
    [_invocation getArgument:argumentLocation atIndex:idx];
}

- (void)setArgument:(void *)argumentLocation atIndex:(NSInteger)idx {
    [_invocation setArgument:argumentLocation atIndex:idx];
}

- (BOOL)isPerformed {
    return _performed;
}

- (void)proceed {
    if (!_performed) {
        _performed = YES;
        [[self getInvocation] invoke];
    }
}

@end
