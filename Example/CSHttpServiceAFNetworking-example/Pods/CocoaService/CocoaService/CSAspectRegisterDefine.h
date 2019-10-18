//
//  CSAspectRegisterDefine.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSAspect.h"

/**
 CSAspect 定义
 */
@protocol CSAspectRegisterDefine <NSObject>

/**
 切面id
 */
- (NSString*)aspectId;

/**
 所属模块
 */
- (NSString*)belongModuleId;

/**
 切面类
 */
- (Class)aspectClass;

@end
