//
//  CSModule.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMacroDefines.h"
#import "CSApplicationContext.h"
#import "CSModuleContext.h"
#import "CSModuleAppDelegateListener.h"


#define WJ_MODULE_LOADING_PRIORITY_HIGH           100

#define WJ_MODULE_LOADING_PRIORITY_DEFAULT         50

#define WJ_MODULE_LOADING_PRIORITY_LOW              0


/**
 模块加载模式
 */
typedef NS_ENUM(NSInteger, CSModuleLoadingMode) {
    
    //应用程序启动后
    CSModuleLoadingModeLaunchedAfter = 0,
    
    //即时加载
    CSModuleLoadingModeInstant = 1,
};

//模块接口
@protocol CSModule <UIApplicationDelegate>

@property (nonatomic, weak) id<CSModuleContext> modContext;

@optional

/**
 模块id，
 default：ClassName
 */
+ (NSString*)moduleId;

/**
 加载优先级
 0~100，值越大越优先加载，默认值：50
 */
+ (int)modulePriority;

/**
 模块加载模式
 default：CSModuleLoadingModeInstant（即时加载）
 */
+ (CSModuleLoadingMode)moduleLoadingMode;

/**
 引用程序回调监听器
 */
+ (Class<CSModuleAppDelegateListener>)applicationDelegateListenerClass;

/**
 模块初始化
 */
- (void)onModuleInit:(id<CSApplicationContext>)applicationContext;

/**
 准备加载
 */
- (void)onModuleWillLoad:(id<CSApplicationContext>)applicationContext;

/**
 已加载
 */
- (void)onModuleDidLoad:(id<CSApplicationContext>)applicationContext;

/**
 准备卸载
 */
- (void)onModuleWillDestroy:(id<CSApplicationContext>)applicationContext;

/**
 已卸载
 */
- (void)onModuleDidDestroy:(id<CSApplicationContext>)applicationContext;


@end
