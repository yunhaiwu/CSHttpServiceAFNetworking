//
//  CSModuleContainer.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSModuleContainer.h"
#import "CSSimpleModuleRegisterDefine.h"
#import "CSMacroDefines.h"
#import "CSSafeDictionary.h"
#import "CSSimpleModuleContext.h"
#import "CSTaskScheduler.h"
#import <WJLoggingAPI/WJLoggingAPI.h>
#import "CSMonitorContext.h"


@interface CSModuleContainer ()

@property (nonatomic, strong) CSSafeDictionary<NSString*, CSSimpleModuleContext*> *moduleIdToContext;

//需要排序
@property (nonatomic, strong) NSMutableArray<id<CSModuleRegisterDefine>> *launchedAfterNeedsLoadModules;


@property (nonatomic, strong) dispatch_semaphore_t module_register_semaphore;

//dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
//dispatch_semaphore_signal(_semaphore);

@end

@implementation CSModuleContainer

- (instancetype)initWithApplicationContext:(id<CSApplicationContext>)applicationContext delegate:(id<CSModuleContainerDelegate>)delegate {
    self = [super init];
    if (self) {
        WJLogDebug(@"✅ module container initialize ......");
        self.module_register_semaphore = dispatch_semaphore_create(1);
        self.applicationContext = applicationContext;
        self.delegate = delegate;
        self.moduleIdToContext = [[CSSafeDictionary alloc] init];
        self.launchedAfterNeedsLoadModules = [[NSMutableArray alloc] init];
        //添加调度任务
        [[CSTaskScheduler sharedInstance] addBlockTask:^{
            [[[CSMonitorContext sharedInstance] applicationTimeProfiler] beginApplicationLaunchedAfterModulesLoading];
            NSArray<id<CSModuleRegisterDefine>> *sortedModRegisterDefines = [self.launchedAfterNeedsLoadModules sortedArrayUsingComparator:^NSComparisonResult(id<CSModuleRegisterDefine>  _Nonnull obj1, id<CSModuleRegisterDefine>  _Nonnull obj2) {
                if ([obj1 modulePriority] > [obj2 modulePriority]) {
                    return NSOrderedAscending;
                } else if ([obj1 modulePriority] < [obj2 modulePriority]) {
                    return NSOrderedDescending;
                }
                return NSOrderedSame;
            }];
            for (NSUInteger i = 0; i < [sortedModRegisterDefines count]; i ++) {
                id<CSModuleRegisterDefine> define = sortedModRegisterDefines[i];
                [self startLoadingModule:define];
            }
            self.launchedAfterNeedsLoadModules = nil;
            [[[CSMonitorContext sharedInstance] applicationTimeProfiler] endApplicationLaunchedAfterModulesLoading];
        }];
    }
    return self;
}

- (void)registerModule:(id<CSModuleRegisterDefine>)define {
    if ([[CSTaskScheduler sharedInstance] isAppLaunched]) {
        //应用程序启动完成直接加载
        [self startLoadingModule:define];
    } else {
        //应用程序未启动完成需要判断加载模式
        CSModuleLoadingMode mode = [define moduleLoadingMode];
        switch (mode) {
            case CSModuleLoadingModeInstant:
                //即时加载
                [[[CSMonitorContext sharedInstance] applicationTimeProfiler] beginApplicationInstantModulesLoading];
                [self startLoadingModule:define];
                [[[CSMonitorContext sharedInstance] applicationTimeProfiler] endApplicationInstantModulesLoading];
                break;
            case CSModuleLoadingModeLaunchedAfter:
                //延后加载
                [self.launchedAfterNeedsLoadModules addObject:define];
                break;
            default:
                break;
        }
    }
}

- (NSString*)getModuleId:(Class)modClass {
    if ([modClass conformsToProtocol:@protocol(CSModule)]) {
        return [modClass moduleId];
    }
    return nil;
}

- (void)unRegisterModule:(Class<CSModule>)modClass {
    NSString *moduleId = [self getModuleId:modClass];
    if ([moduleId isEqualToString:CSApplicationCoreModuleId]) {
        //应用程序默认模块不能卸载
        WJLogError(@"❌ module unregister error: module '%@' not found", CSApplicationCoreModuleId);
        return;
    }
    dispatch_semaphore_wait(_module_register_semaphore, DISPATCH_TIME_FOREVER);
    @try {
        CSSimpleModuleContext *context = [self.moduleIdToContext objectForKey:moduleId];
        if (context) {
            [context triggerModuleStatus:CSModuleStatusWillDestroy];
            if ([self.delegate respondsToSelector:@selector(moduleContainer:willDestroyModule:)]) {
                [self.delegate moduleContainer:self willDestroyModule:context];
            }
            
            if ([context applicationDelegateListener]) {
                [self.delegate moduleContainer:self unRegisterAppDelegateListener:[context applicationDelegateListener]];
            }
            [self.moduleIdToContext removeObjectForKey:[context moduleId]];
            
            [context triggerModuleStatus:CSModuleStatusDidDestroy];
            if ([self.delegate respondsToSelector:@selector(moduleContainer:didDestroyModule:)]) {
                [self.delegate moduleContainer:self didDestroyModule:context];
            }
        }
    } @catch (NSException *exception) {
        WJLogError(@"❌ module unregister fail, (%@) exception:%@", moduleId, exception);
    } @finally {
        dispatch_semaphore_signal(_module_register_semaphore);
    }
}

- (void)startLoadingModule:(id<CSModuleRegisterDefine>)define {
    NSString *moduleId = [define moduleId];
    if ([self.moduleIdToContext objectForKey:moduleId]) {
        WJLogError(@"❌ module register fail , '%@' already exists", moduleId);
        return;
    }
    [[[CSMonitorContext sharedInstance] applicationTimeProfiler] beginModuleLoading:moduleId];
    dispatch_semaphore_wait(_module_register_semaphore, DISPATCH_TIME_FOREVER);
    @try {
        WJLogDebug(@"✅ module loding '%@' start ...", moduleId);
        CSSimpleModuleContext *context = [CSSimpleModuleContext buildContext:define applicationContext:self.applicationContext];
        [context triggerModuleStatus:CSModuleStatusInitialized];
        if ([context applicationDelegateListener]) {
            [self.delegate moduleContainer:self registerAppDelegateListener:[context applicationDelegateListener]];
        }
        if ([self.delegate respondsToSelector:@selector(moduleContainer:willLoadModule:)]) {
            [self.delegate moduleContainer:self willLoadModule:context];
        }
        [context triggerModuleStatus:CSModuleStatusWillLoading];
        
        [self.moduleIdToContext setObject:context forKey:[context moduleId]];
        if ([self.delegate respondsToSelector:@selector(moduleContainer:didLoadModule:)]) {
            [self.delegate moduleContainer:self didLoadModule:context];
        }
        [context triggerModuleStatus:CSModuleStatusDidLoading];
        WJLogDebug(@"✅ module loding '%@' finished ...", moduleId);
    } @catch (NSException *exception) {
        WJLogError(@"❌ module loading fail, (%@) exception:%@", moduleId, exception);
    } @finally {
        dispatch_semaphore_signal(_module_register_semaphore);
        [[[CSMonitorContext sharedInstance] applicationTimeProfiler] endModuleLoading:moduleId];
    }
}

@end
