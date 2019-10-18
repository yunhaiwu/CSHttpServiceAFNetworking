//
//  CSMonitorContext.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSMonitorContext.h"



@interface CSMonitorContext ()

@property (nonatomic, strong) CSMonitorTimeProfiler *timeProfiler;

@end


@implementation CSMonitorContext

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timeProfiler = [[CSMonitorTimeProfiler alloc] init];
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

- (CSMonitorTimeProfiler *)timeProfiler {
    return _timeProfiler;
}

@end
