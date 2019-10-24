//
//  CSSimpleModuleContext.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSModuleContext.h"
#import "CSModuleRegisterDefine.h"

__attribute__((objc_subclassing_restricted))
@interface CSSimpleModuleContext : NSObject<CSModuleContext>

/**
 当前模块状态
 */
@property (nonatomic, assign, readonly) CSModuleStatus moduleStatus;

/**
 构建一个Mod Context
 @param moduleRegisterDefine 模块定义
 @return 模块环境实例
 */
+ (instancetype)buildContext:(id<CSModuleRegisterDefine>)moduleRegisterDefine applicationContext:(id<CSApplicationContext>)applicationContext;

/**
 触发状态
 */
- (void)triggerModuleStatus:(CSModuleStatus)moduleStatus;

/**
 应用程序委托监听
 */
- (id<CSModuleAppDelegateListener>)applicationDelegateListener;

@end
