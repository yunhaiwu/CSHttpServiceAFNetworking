//
//  CSModuleContext.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 模块状态
 */
typedef NS_ENUM(NSInteger, CSModuleStatus) {
    
    //未加载
    CSModuleStatusNotLoaded         = 0,
    
    //已初始化
    CSModuleStatusInitialized       = 1,
    
    //准备加载
    CSModuleStatusWillLoading       = 2,
    
    //已加载
    CSModuleStatusDidLoading        = 3,
    
    //准备卸载
    CSModuleStatusWillDestroy       = 4,
    
    //已卸载
    CSModuleStatusDidDestroy        = 5,
    
};

/**
 模块上下文环境
 */
@protocol CSModuleContext <NSObject>

/**
 当前模块状态
 */
@property (nonatomic, assign, readonly) CSModuleStatus moduleStatus;


- (NSString*)moduleId;

/**
 优先级
 */
- (int)modulePriority;

/**
 模块加载模式
 */
- (NSInteger)moduleLoadingMode;

@end
