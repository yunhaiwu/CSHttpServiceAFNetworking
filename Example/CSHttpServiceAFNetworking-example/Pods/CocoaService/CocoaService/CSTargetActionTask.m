//
//  CSTargetActionTask.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSTargetActionTask.h"

@implementation CSTargetActionTask

- (instancetype)initWithTarget:(id)target action:(SEL)action async:(BOOL)async {
    self = [super init];
    if (self) {
        self.target = target;
        self.action = action;
        self.async = async;
    }
    return self;
}

- (BOOL)isAsync {
    return _async;
}

- (void)trigger {
    if ([_target respondsToSelector:_action]) {
        @try {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.action];
#pragma clang diagnostic pop
        } @catch (NSException *exception) {
        }
    }
}

@end
