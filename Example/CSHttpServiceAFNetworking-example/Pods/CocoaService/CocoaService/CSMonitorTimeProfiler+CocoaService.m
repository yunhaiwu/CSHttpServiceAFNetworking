//
//  CSMonitorTimeProfiler+CocoaService.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSMonitorTimeProfiler+CocoaService.h"

@implementation CSMonitorTimeProfiler (CocoaService)

- (void)beginAppLaunched {
    [self beginTime:@"application launched"];
}

- (void)endAppLaunched {
    [self endTime:@"application launched"];
}

- (void)beginAppModuleLoading:(NSString*) moduleId {
    [self beginTime:[NSString stringWithFormat:@"module loading - '%@'", moduleId]];
}

- (void)endAppModuleLoading:(NSString*) moduleId {
    [self endTime:[NSString stringWithFormat:@"module loading - '%@'", moduleId]];
}

- (void)beginAppModuleLoadingInstant {
    [self beginTime:@"instant modules loading"];
}

- (void)endAppModuleLoadingInstant {
    [self cumulativeTime:@"instant modules loading"];
}

- (void)beginAppModuleLoadingLaunchedAfter {
    [self beginTime:@"launched after modules loading"];
}

- (void)endAppModuleLoadingLaunchedAfter {
    [self cumulativeTime:@"launched after modules loading"];
}

- (void)beginAppDataPreload {
    [self beginTime:@"application preload data"];
}

- (void)endAppDataPreload {
    [self endTime:@"application preload data"];
}

- (void)beginAnnotationRead {
    [self beginTime:@"application annotation parsing"];
}

- (void)endAnnotationRead {
    [self cumulativeTime:@"application annotation parsing"];
}

- (void)getCocoaServiceTimeProfileReport:(void(^)(NSDictionary *timeProfiles))callbackBlock {
    NSArray *names = @[@"application annotation parsing",
                       @"application preload data",
                       @"instant modules loading",
                       @"launched after modules loading",
                       @"application launched",];
    [self getTimeProfiles:names callbackBlock:callbackBlock];
}

@end
