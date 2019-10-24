//
//  CSBlockTask.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSBlockTask.h"

@implementation CSBlockTask

- (instancetype)initWithBlock:(CSTaskBlock)block async:(BOOL)async {
    self = [super init];
    if (self) {
        self.taskBlock = block;
        self.async = async;
    }
    return self;
}

- (instancetype)initWithBlock:(CSTaskBlock)taskBlock completion:(CSTaskCompletionBlock)completionBlock async:(BOOL)async {
    self = [super init];
    if (self) {
        self.taskBlock = taskBlock;
        self.completionBlock = completionBlock;
        self.async = async;
    }
    return self;
}

- (BOOL)isAsync {
    return _async;
}

- (void)trigger {
    if (_taskBlock) {
        _taskBlock();
        if (_completionBlock) {
            _completionBlock();
        }
    }
}

@end
