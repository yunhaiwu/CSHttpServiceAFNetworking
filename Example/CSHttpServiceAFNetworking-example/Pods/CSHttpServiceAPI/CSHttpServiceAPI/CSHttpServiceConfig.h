//
//  CSHttpServiceConfig.h
//  CocoaService-HttpServiceAPI
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

//最大并发数
#define CSHttpServiceDefaultMaxConcurrentNumber     5

//默认超时时间（以秒为单位）
#define CSHttpServiceDefaultTimeoutBySeconds        30

/*
 服务配置
 */
@protocol CSHttpServiceConfig <NSObject>

/*
 服务最大并发数
 default 5
 */
- (NSUInteger)maxConcurrentNumber;

/*
 默认超时时长
 default 30 seconds
 */
- (int)defaultTimeoutBySeconds;

@end
