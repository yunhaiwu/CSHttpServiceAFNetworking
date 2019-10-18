//
//  CSMonitorTimeProfiler+CocoaService.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSMonitorTimeProfiler.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSMonitorTimeProfiler (CocoaService)

- (void)beginAppLaunched;

- (void)endAppLaunched;

- (void)beginAppModuleLoading:(NSString*) moduleId;

- (void)endAppModuleLoading:(NSString*) moduleId;

- (void)beginAppModuleLoadingInstant;

- (void)endAppModuleLoadingInstant;

- (void)beginAppModuleLoadingLaunchedAfter;

- (void)endAppModuleLoadingLaunchedAfter;

- (void)beginAppDataPreload;

- (void)endAppDataPreload;

- (void)beginAnnotationRead;

- (void)endAnnotationRead;

/*
 获取CocoaService时间分析报告
 */
- (void)getCocoaServiceTimeProfileReport:(void(^)(NSDictionary *timeProfiles))callbackBlock;

@end

NS_ASSUME_NONNULL_END
