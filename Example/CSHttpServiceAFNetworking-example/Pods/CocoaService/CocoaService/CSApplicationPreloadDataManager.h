//
//  CSApplicationPreloadDataManager.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSServiceRegisterDefine.h"
#import "CSModuleRegisterDefine.h"
#import "CSAppFirstViewControllerDefine.h"
#import "CSAspectRegisterDefine.h"

/**
 应用程序预加载管理
 */
__attribute__((objc_subclassing_restricted))
@interface CSApplicationPreloadDataManager : NSObject

/*
 单例
 */
+ (instancetype)sharedInstance;

/*
 应用程序第一个出现的VC集合
 */
- (NSSet<id<CSAppFirstViewControllerDefine>>*)getAppFirstViewControllerDefineSet;

/**
 获取有用程序全局默认模块定义
 */
- (id<CSModuleRegisterDefine>)generateModuleRegisterDefine:(Class<CSModule>)modClass;

/**
 获取模块定义列表

 @return module 定义集合
 */
- (NSSet<id<CSModuleRegisterDefine>>*)getModuleRegisterDefineSet;

/**
 获取所属模块service defines
 
 @param moduleId 模块id
 @return service 定义集合
 */
- (NSSet<id<CSServiceRegisterDefine>>*)getServiceRegisterDefineSet:(NSString*)moduleId;



/**
 获取所属模块aspects defines
 @param moduleId 模块id
 @return aspect 定义集合
 */
- (NSSet<id<CSAspectRegisterDefine>>*)getAspectRegisterDefineSet:(NSString*)moduleId;

@end
