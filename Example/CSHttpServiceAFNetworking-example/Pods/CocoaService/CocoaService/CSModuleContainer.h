//
//  CSModuleContainer.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSModuleRegisterDefine.h"
#import "CSApplicationContext.h"
#import "CSModuleAppDelegateListener.h"
#import "CSModuleContext.h"

@class CSModuleContainer;

@protocol CSModuleContainerDelegate <NSObject>

- (void)moduleContainer:(CSModuleContainer*)modContainer registerAppDelegateListener:(id<CSModuleAppDelegateListener>)listener;

- (void)moduleContainer:(CSModuleContainer*)modContainer unRegisterAppDelegateListener:(id<CSModuleAppDelegateListener>)listener;

@optional

- (void)moduleContainer:(CSModuleContainer *)modContainer willLoadModule:(id<CSModuleContext>)moduleContext;

- (void)moduleContainer:(CSModuleContainer *)modContainer didLoadModule:(id<CSModuleContext>)moduleContext;

- (void)moduleContainer:(CSModuleContainer *)modContainer willDestroyModule:(id<CSModuleContext>)moduleContext;

- (void)moduleContainer:(CSModuleContainer *)modContainer didDestroyModule:(id<CSModuleContext>)moduleContext;

@end


/**
 模块容器，模块管理，注册、卸载、应用程序回调分发
 */
__attribute__((objc_subclassing_restricted))
@interface CSModuleContainer : NSObject

@property (nonatomic, weak) id<CSApplicationContext> applicationContext;

@property (nonatomic, weak) id<CSModuleContainerDelegate> delegate;

/**
 初始化方法
 @param applicationContext 应用程序上下文环境
 @param delegate 委托
 @return 模块容器
 */
- (instancetype)initWithApplicationContext:(id<CSApplicationContext>)applicationContext delegate:(id<CSModuleContainerDelegate>)delegate;

/**
 注册模块
 @param define 模块定义
 */
- (void)registerModule:(id<CSModuleRegisterDefine>)define;

/**
 卸载模块
 */
- (void)unRegisterModule:(Class<CSModule>)modClass;

@end
