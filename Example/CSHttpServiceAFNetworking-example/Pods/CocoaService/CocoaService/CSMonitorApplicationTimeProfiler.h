//
//  CSMonitorApplicationTimeProfiler.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSMonitorTimeProfiler.h"

/*
 应用程序时间分析器
 */
@interface CSMonitorApplicationTimeProfiler : NSObject

- (instancetype _Nonnull )initWithTimeProfiler:(CSMonitorTimeProfiler*_Nonnull)timeProfiler;

/*
 应用程序开始启动
 */
- (void)beginApplicationLaunched;

/*
 应用程序完成启动
 */
- (void)endApplicationLaunched;

/*
 模块开始加载
 */
- (void)beginModuleLoading:(NSString* _Nonnull)moduleId;

/*
 模块结束加载
 */
- (void)endModuleLoading:(NSString* _Nonnull)moduleId;

/*
 即时启动模块开始加载
 */
- (void)beginApplicationInstantModulesLoading;

/*
 即时启动模块结束加载
 */
- (void)endApplicationInstantModulesLoading;

/*
 后置模块开始加载
 */
- (void)beginApplicationLaunchedAfterModulesLoading;

/*
后置模块结束加载
*/
- (void)endApplicationLaunchedAfterModulesLoading;

/*
 应用程序数据预加载开始
 */
- (void)beginApplicationDataPreload;

/*
应用程序数据预加载结束
*/
- (void)endApplicationDataPreload;

/*
 注解读取开始
 */
- (void)beginAnnotationRead;

/*
注解读取结束
*/
- (void)endAnnotationRead;

/*
 应用程序时间分析报告日志(异步)
 */
- (void)getApplicationTimeProfileLogReport:(void(^_Nonnull)(NSString* _Nullable logReport))callbackBlock;

/*
 纯数据报告/毫秒(异步)
 */
- (void)getApplicationTimeProfileReport:(void(^_Nonnull)(NSDictionary<NSString*, NSNumber*>* _Nullable report))callbackBlock;

@end
