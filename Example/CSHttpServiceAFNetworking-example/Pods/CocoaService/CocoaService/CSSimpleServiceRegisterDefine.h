//
//  CSSimpleServiceRegisterDefine.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSServiceRegisterDefine.h"

/**
 服务注册定义
 */
@interface CSSimpleServiceRegisterDefine : NSObject<CSServiceRegisterDefine>


+ (instancetype)buildDefine:(Protocol*)protocol serviceClass:(Class)serviceClass;

/**
 添加Service Class
 */
- (void)appendServiceClass:(Class)serviceClass;

@end
