//
//  CSTaskScheduler.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSTaskTargetActionTask.h"
#import "CSTaskBlockTask.h"


/**
 应用程序任务调度器
 */
__attribute__((objc_subclassing_restricted))
@interface CSTaskScheduler : NSObject

/**
 应用是否已启动完成
 */
@property (atomic, assign, readonly) BOOL isApplicationLaunched;


/*
 获取单利
 */
+ (instancetype)sharedInstance;

/**
 添加block任务
 注意：如果isApplicationLaunched=YES，task会被立刻执行
 */
- (void)addBlockTask:(CSTaskBlock)taskBlock;

/**
 添加block任务
 @param taskBlock 任务block
 @param isAsync 是否异步
 注意：如果isApplicationLaunched=YES，task会被立刻执行
 */
- (void)addBlockTask:(CSTaskBlock)taskBlock isAsync:(BOOL)isAsync;

/**
 添加target任务
 注意：如果isApplicationLaunched=YES，task会被立刻执行
 */
- (void)addTargetTask:(id)target action:(SEL)action;

/**
 添加target任务
 @param target 任务target
 @param action 任务action
 @param isAsync 是否异步执行
 注意：如果isApplicationLaunched=YES，task会被立刻执行
 */
- (void)addTargetTask:(id)target action:(SEL)action isAsync:(BOOL)isAsync;

/**
 添加自定义任务
 @param task 任务对象
 */
- (void)addTask:(id<CSTask>)task;


@end
