//
//  CSServiceWrapper.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Service包装器（Service定义、service实例构建）
 */
@interface CSServiceWrapper : NSObject

/**
 初始化方法
 */
- (instancetype)initWithServiceClass:(Class)class;


/**
 添加protocol

 @param protocolName 协议名称
 @return 是否添加成功，如果NO，表示已存在，无需添加
 */
- (BOOL)addReferenceProtocol:(NSString*)protocolName;

/**
 移除protocol
 */
- (void)removeReferenceProtocol:(NSString*)protocolName;

/**
 是否存在其他Protocol引用
 */
- (BOOL)hasProtocolReferences;

/**
 服务Class
 */
- (Class)getServiceClass;

/**
 服务Id
 */
- (NSString*)getServiceId;

/**
 服务对象
 */
- (id)getServiceObject;

/**
 模块Id
 */
- (NSString*)getBelongModuleId;

@end
