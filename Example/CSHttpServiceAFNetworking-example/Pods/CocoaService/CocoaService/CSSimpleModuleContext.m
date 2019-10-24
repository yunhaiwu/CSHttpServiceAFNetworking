//
//  CSSimpleModuleContext.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSSimpleModuleContext.h"
#import <WJLoggingAPI/WJLoggingAPI.h>

@interface CSSimpleModuleContext ()

@property (nonatomic, strong) id<CSModuleRegisterDefine> modRegisterDefine;

@property (nonatomic, strong) id<CSModule> module;

@property (nonatomic, strong) id<CSModuleAppDelegateListener> appDelegateListener;

@property (nonatomic, weak) id<CSApplicationContext> applicationContext;

@end

@implementation CSSimpleModuleContext

- (instancetype)initWithModRegisterDefine:(id<CSModuleRegisterDefine>)modRegisterDefine applicationContext:(id<CSApplicationContext>)applicationContext {
    self = [super init];
    if (self) {
        self.applicationContext = applicationContext;
        self.modRegisterDefine = modRegisterDefine;
    }
    return self;
}

+ (instancetype)buildContext:(id<CSModuleRegisterDefine>)moduleRegisterDefine applicationContext:(id<CSApplicationContext>)applicationContext {
    if (moduleRegisterDefine) {
        return [[CSSimpleModuleContext alloc] initWithModRegisterDefine:moduleRegisterDefine applicationContext:applicationContext];
    }
    return nil;
}

- (id<CSModuleAppDelegateListener>)applicationDelegateListener {
    return _appDelegateListener;
}

- (NSString*)moduleId {
    return [_modRegisterDefine moduleId];;
}

- (NSUInteger)modulePriority {
    return [_modRegisterDefine modulePriority];
}

- (NSInteger)moduleLoadingMode {
    return [_modRegisterDefine moduleLoadingMode];
}

- (void)changeModuleStatus:(CSModuleStatus)moduleStatus {
    if (_moduleStatus == moduleStatus) {
        return;
    }
    [self willChangeValueForKey:@"moduleStatus"];
    _moduleStatus = moduleStatus;
    [self didChangeValueForKey:@"moduleStatus"];
}

- (void)triggerModuleStatus:(CSModuleStatus)moduleStatus {
    switch (moduleStatus) {
        case CSModuleStatusInitialized:
        {
            NSAssert(_moduleStatus == CSModuleStatusNotLoaded, @"❌ module init fail, moduleStatus != NotLoaded");
            if ([[_modRegisterDefine moduleClass] respondsToSelector:@selector(applicationDelegateListenerClass)]) {
                Class listenerClass = [[_modRegisterDefine moduleClass] applicationDelegateListenerClass];
                if ([listenerClass conformsToProtocol:@protocol(CSModuleAppDelegateListener)]) {
                    self.appDelegateListener = [[listenerClass alloc] init];
                }
            }
            self.module = [[[_modRegisterDefine moduleClass] alloc] init];
            [self.module setModContext:self];
            [self changeModuleStatus:CSModuleStatusInitialized];
            if ([self.module respondsToSelector:@selector(onModuleInit:)]) {
                [self.module onModuleInit:_applicationContext];
            }
        }
            break;
        case CSModuleStatusWillLoading:
        {
            NSAssert(_moduleStatus == CSModuleStatusInitialized, @"❌ module will loading fail, moduleStatus != Initialized");
            [self changeModuleStatus:moduleStatus];
            if ([_module respondsToSelector:@selector(onModuleWillLoad:)]) {
                [_module onModuleWillLoad:_applicationContext];
            }
        }
            break;
        case CSModuleStatusDidLoading:
        {
            NSAssert(_moduleStatus == CSModuleStatusWillLoading, @"❌ module did loading fail, moduleStatus != WillLoading");
            [self changeModuleStatus:moduleStatus];
            if ([_module respondsToSelector:@selector(onModuleDidLoad:)]) {
                [_module onModuleDidLoad:_applicationContext];
            }
        }
            break;
        case CSModuleStatusWillDestroy:
        {
            NSAssert(_moduleStatus == CSModuleStatusDidLoading, @"❌ module will destroy fail, moduleStatus != DidLoading");
            [self changeModuleStatus:moduleStatus];
            if ([_module respondsToSelector:@selector(onModuleWillDestroy:)]) {
                [_module onModuleWillDestroy:_applicationContext];
            }
        }
            break;
        case CSModuleStatusDidDestroy:
        {
            NSAssert(_moduleStatus == CSModuleStatusWillDestroy, @"❌ module did destroy fail, moduleStatus != WillDestroy");
            [self changeModuleStatus:moduleStatus];
            if ([_module respondsToSelector:@selector(onModuleDidDestroy:)]) {
                [_module onModuleDidDestroy:_applicationContext];
            }
        }
            break;
        default:
            break;
    }
}

@end
