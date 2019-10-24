//
//  CSTaskScheduler.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSTask.h"
#import "CSTargetActionTask.h"
#import "CSBlockTask.h"


/*
 应用程序任务调度器
 */
__attribute__((objc_subclassing_restricted))
@interface CSTaskScheduler : NSObject

/*
 应用是否已启动完成
 */
@property (atomic, assign, readonly) BOOL isAppLaunched;

/*
 获取单利
 */
+ (instancetype _Nonnull )sharedInstance;

/*
 添加block任务
 注意：如果isAppLaunched=YES，task会被立刻执行
 */
- (void)addBlockTask:(_Nonnull CSTaskBlock)taskBlock;

/*
 添加block任务
 @param taskBlock 任务block
 @param isAsync 是否异步
 注意：如果isAppLaunched=YES，task会被立刻执行
 */
- (void)addBlockTask:(_Nonnull CSTaskBlock)taskBlock isAsync:(BOOL)isAsync;

/*
 添加target任务
 注意：如果isAppLaunched=YES，task会被立刻执行
 */
- (void)addTargetTask:(_Nonnull id)target action:(SEL _Nonnull )action;

/*
 添加target任务
 @param target 任务target
 @param action 任务action
 @param isAsync 是否异步执行
 注意：如果isAppLaunched=YES，task会被立刻执行
 */
- (void)addTargetTask:(_Nonnull id)target action:(SEL _Nonnull )action isAsync:(BOOL)isAsync;

/*
 添加自定义任务
 @param task 任务对象
 */
- (void)addTask:(_Nonnull id<CSTask>)task;


@end
