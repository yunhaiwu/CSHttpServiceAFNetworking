//
//  CSTaskScheduler.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSTaskScheduler.h"
#import <UIKit/UIKit.h>
#import "CSRuntimeTool.h"
#import "CSMonitorContext.h"
#import "CSSafeQueue.h"
#import <WJLoggingAPI/WJLoggingAPI.h>
#import "CSApplicationPreloadDataManager.h"

@interface UIViewController (TaskScheduler)

-(void)taskScheduler_viewDidAppear:(BOOL)animated;

@end

@interface CSTaskScheduler ()

@property (nonatomic, strong) CSSafeQueue<id<CSTask>> *taskQueue;

@property (nonatomic, strong) dispatch_queue_t task_execution_queue;

@end

@implementation CSTaskScheduler

- (void)hookFirstViewControllersViewDidAppear {
    [CSRuntimeTool swizzleInstanceMethodWithClass:[UIViewController class] orginalMethod:@selector(viewDidAppear:) replaceMethod:@selector(taskScheduler_viewDidAppear:)];
}

+ (instancetype)sharedInstance {
    static CSTaskScheduler *sharedObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[CSTaskScheduler alloc] init];
        [sharedObject hookFirstViewControllersViewDidAppear];
    });
    return sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.taskQueue = [[CSSafeQueue alloc] init];
        self.task_execution_queue = dispatch_queue_create("com.cocoaservice.task.scheduler.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)addBlockTask:(CSTaskBlock)taskBlock {
    [self addBlockTask:taskBlock isAsync:NO];
}

- (void)addBlockTask:(CSTaskBlock)taskBlock isAsync:(BOOL)isAsync {
    CSBlockTask *task = [[CSBlockTask alloc] initWithBlock:taskBlock async:isAsync];
    [self addTask:task];
}

- (void)addTargetTask:(id)target action:(SEL)action {
    [self addTargetTask:target action:action isAsync:NO];
}

- (void)addTargetTask:(id)target action:(SEL)action isAsync:(BOOL)isAsync {
    CSTargetActionTask *task = [[CSTargetActionTask alloc] initWithTarget:target action:action async:isAsync];
    [self addTask:task];
}

- (void)addTask:(id<CSTask>)task {
    if (_isAppLaunched) {
        [self handleTask:task];
    } else {
        [self.taskQueue put:task];
    }
}

- (void)handleTask:(id<CSTask>)task {
    if ([task isAsync]) {
        dispatch_async(self.task_execution_queue, ^{
            @try {
                [task trigger];
            } @catch (NSException *exception) {
                WJLogError(@"❌ TaskScheduler perform task exction:%@", exception);
            }
        });
    } else {
        @try {
            [task trigger];
        } @catch (NSException *exception) {
            WJLogError(@"❌ TaskScheduler perform task exction:%@", exception);
        }
    }
    
}

- (void)triggerScheduleTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //重新交换UIViewController的viewDidAppear:
        [self hookFirstViewControllersViewDidAppear];
        [[[CSMonitorContext sharedInstance] applicationTimeProfiler] endApplicationLaunched];
        [self willChangeValueForKey:@"isAppLaunched"];
        _isAppLaunched = YES;
        [self didChangeValueForKey:@"isAppLaunched"];
        while (![self.taskQueue isEmpty]) {
            id<CSTask> task = [self.taskQueue poll];
            [self handleTask:task];
        }
#ifdef DEBUG
        //application loading report info
        [self addBlockTask:^{
            [[[CSMonitorContext sharedInstance] applicationTimeProfiler] getApplicationTimeProfileLogReport:^(NSString * logReport) {
                WJLogDebug(@"%@", logReport);
            }];
        }];
#endif
    });
}

@end

@implementation UIViewController (TaskScheduler)

-(void)taskScheduler_viewDidAppear:(BOOL)animated {
    [self taskScheduler_viewDidAppear:animated];
    if (![[CSTaskScheduler sharedInstance] isAppLaunched]) {
        if ([[CSApplicationPreloadDataManager sharedInstance] getFirstViewControllerClassSet]) {
            if ([[[CSApplicationPreloadDataManager sharedInstance] getFirstViewControllerClassSet] containsObject:[self class]]) {
                [[CSTaskScheduler sharedInstance] triggerScheduleTasks];
            }
        } else {
            [[CSTaskScheduler sharedInstance] triggerScheduleTasks];
        }
    }
}

@end
