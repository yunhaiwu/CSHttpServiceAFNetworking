//
//  CSHttpService.h
//  CocoaService-HttpServiceAPI
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaService/CSService.h>
#import "CSHttpRequest.h"
#import "CSHttpResponse.h"
#import "CSHttpTask.h"

typedef void(^CSHttpServiceResponseBlock)(id<CSHttpResponse> _Nullable response, NSError * _Nullable error);

typedef void(^CSHttpServiceResponseDataBlock)(NSData * _Nullable responseData, NSError * _Nullable error);

typedef void (^CSHttpServiceDownloadResponseBlock)(NSString* _Nullable filePath, NSError * _Nullable error);

typedef void (^CSHttpServiceProgressBlock)(float progress);



/*
 HTTP 服务接口
 */
@protocol CSHttpService <CSService>

- (id<CSHttpTask> _Nullable)request:(id<CSHttpRequest> _Nonnull)request
  responseClass:(Class _Nonnull)resClass
  responseBlock:(CSHttpServiceResponseBlock _Nonnull)responseBlock;


- (id<CSHttpTask> _Nullable)requestWithURL:(NSURL* _Nonnull)url
                method:(CSHTTPMethod)method
                params:(NSDictionary<NSString*, NSObject*>* _Nullable)params
               headers:(NSDictionary<NSString*, NSString*>* _Nullable)headers
         responseBlock:(CSHttpServiceResponseDataBlock _Nonnull) responseBlock;


- (id<CSHttpTask> _Nullable)downloadWithURL:(NSURL* _Nonnull)url
          responseBlock:(CSHttpServiceDownloadResponseBlock _Nonnull)downloadResponseBlock
               progress:(CSHttpServiceProgressBlock _Nullable)progressBlock;

@end
