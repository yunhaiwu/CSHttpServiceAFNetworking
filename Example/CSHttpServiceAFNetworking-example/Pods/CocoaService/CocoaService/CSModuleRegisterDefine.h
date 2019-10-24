//
//  CSModuleRegisterDefine.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSModule.h"

/**
 模块注册描述协议
 */
@protocol CSModuleRegisterDefine <NSObject>

/**
 模块ID
 */
- (NSString*)moduleId;

/**
 模块优先级
 */
- (NSUInteger)modulePriority;

/**
 模块加载模式
 */
- (CSModuleLoadingMode)moduleLoadingMode;

/**
 模块类型
 */
- (Class)moduleClass;

@end
