//
//  CSMonitorContext.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSMonitorContext.h"

@implementation CSMonitorContext

- (instancetype)init {
    self = [super init];
    if (self) {
        _timeProfiler = [[CSMonitorTimeProfiler alloc] init];
        _applicationTimeProfiler = [[CSMonitorApplicationTimeProfiler alloc] initWithTimeProfiler:_timeProfiler];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static CSMonitorContext *sharedObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[CSMonitorContext alloc] init];
    });
    return sharedObject;
}

@end
