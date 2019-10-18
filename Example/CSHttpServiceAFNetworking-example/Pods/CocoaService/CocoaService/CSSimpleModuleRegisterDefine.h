//
//  CSSimpleModuleRegisterDefine.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSModuleRegisterDefine.h"

/**
 模块注册描述
 */
@interface CSSimpleModuleRegisterDefine : NSObject<CSModuleRegisterDefine>

/**
 注意如果，modClass 没有实现协议CSModule 会返回为nil
 */
+ (CSSimpleModuleRegisterDefine*)buildDefine:(Class<CSModule>)modClass;

@end
