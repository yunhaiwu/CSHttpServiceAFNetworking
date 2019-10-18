//
//  CSServiceRegisterDefine.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 服务注册描述协议
 */
@protocol CSServiceRegisterDefine <NSObject>

/**
 服务协议
 */
- (Protocol*)serviceProtocol;

/**
 服务列表
 */
- (NSSet<Class>*)serviceClassSet;

@end
