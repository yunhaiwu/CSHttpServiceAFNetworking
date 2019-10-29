//
//  CSHttpServiceInterceptor.h
//  CocoaService-HttpServiceAPI
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSHttpRequest.h"
#import "CSHttpResponse.h"

/*
 http 服务拦截器
 */
@protocol CSHttpServiceInterceptor <NSObject>

/*
 请求响应前
 */
-(BOOL)preRequestHandle:(id<CSHttpRequest> _Nonnull)request;

/*
 请求响应后
 */
-(void)afterResponseHandle:(id<CSHttpResponse> _Nonnull)response;

@end
