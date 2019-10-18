//
//  CSService.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 服务协议
 */
@protocol CSService<NSObject>


@optional

/**
 服务是否为单利
 注意：如果是单利，并且没有实现方法 sharedInstance，则会创建并缓存，如果实现sharedInstance方法，拿到对象也会被缓存
 default NO
 @return 服务是否为单利
 */
+ (BOOL)hasSingleton;

/**
 单例
 注意：如果没有此方法则调用customInstance创建
 */
+ (id)sharedInstance;

/**
 自定义实例化类方法
 注意：如果没有此方法则走正常初始化方法  alloc、init
 */
+ (id)customInstance;

/**
 服务id，default ClassName
 @return 服务id
 */
+ (NSString*)serviceId;

/**
 所属模块Id
 */
+ (NSString*)belongModuleId;

@end
