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

- (void)hookAppFirstViewControllersViewDidAppear {
    NSSet<id<CSAppFirstViewControllerDefine>>* vcDefineSet = [[CSApplicationPreloadDataManager sharedInstance] getAppFirstViewControllerDefineSet];
    if ([vcDefineSet count]) {
        NSEnumerator<id<CSAppFirstViewControllerDefine>> *enumerator = [vcDefineSet objectEnumerator];
        id<CSAppFirstViewControllerDefine> define = nil;
        while (define = [enumerator nextObject]) {
            [CSRuntimeTool swizzleInstanceMethodWithClass:[define viewControllerClass] orginalMethod:@selector(viewDidAppear:) replaceMethod:@selector(taskScheduler_viewDidAppear:)];
        }
    }
}

+ (instancetype)sharedInstance {
    static CSTaskScheduler *sharedObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[CSTaskScheduler alloc] init];
        [sharedObject hookAppFirstViewControllersViewDidAppear];
    });
    return sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.taskQueue = [[CSSafeQueue alloc] initWithMaxSize:100];
        self.task_execution_queue = dispatch_queue_create("com.cocoaservice.scheduler.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)addBlockTask:(CSTaskBlock)taskBlock {
    [self addBlockTask:taskBlock isAsync:NO];
}

- (void)addBlockTask:(CSTaskBlock)taskBlock isAsync:(BOOL)isAsync {
    CSTaskBlockTask *task = [[CSTaskBlockTask alloc] initWithBlock:taskBlock async:isAsync];
    [self addTask:task];
}

- (void)addTargetTask:(id)target action:(SEL)action {
    [self addTargetTask:target action:action isAsync:NO];
}

- (void)addTargetTask:(id)target action:(SEL)action isAsync:(BOOL)isAsync {
    CSTaskTargetActionTask *task = [[CSTaskTargetActionTask alloc] initWithTarget:target action:action async:isAsync];
    [self addTask:task];
}

- (void)addTask:(id<CSTask>)task {
    if (_isApplicationLaunched) {
        [self handleTask:task];
    } else {
        [self.taskQueue put:task];
    }
}

- (void)handleTask:(id<CSTask>)task {
    @try {
        if ([task isAsync]) {
            dispatch_async(self.task_execution_queue, ^{
                [task trigger];
            });
        } else {
            [task trigger];
        }
    } @catch (NSException *exception) {
        WJLogError(@"❌ TaskScheduler perform task exction:%@", exception);
    }
}

- (void)triggerScheduleTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[[CSMonitorContext sharedInstance] timeProfiler] endAppLaunched];
        [self willChangeValueForKey:@"isApplicationLaunched"];
        _isApplicationLaunched = YES;
        [self didChangeValueForKey:@"isApplicationLaunched"];
        while (![self.taskQueue isEmpty]) {
            id<CSTask> task = [self.taskQueue poll];
            [self handleTask:task];
        }
    });
}

@end

@implementation UIViewController (TaskScheduler)

-(void)taskScheduler_viewDidAppear:(BOOL)animated {
    [self taskScheduler_viewDidAppear:animated];
    [[CSTaskScheduler sharedInstance] triggerScheduleTasks];
}

@end
