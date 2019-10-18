//
//  CSAspectServiceProxy.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSAspectContext.h"

/**
 服务代理
 */
@interface CSAspectServiceProxy : NSProxy

+ (instancetype)instanceProxy:(id)target aspectFetcher:(NSDictionary<NSString*, NSSet<CSAspectContext*>*>*)methodToAspects;

@end
