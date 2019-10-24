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

typedef void(^CSHttpServiceResponseBlock)(id<CSHttpResponse> response, NSError *error);

typedef void(^CSHttpServiceResponseDataBlock)(NSData *responseData, NSError *error);

typedef void (^CSHttpServiceDownloadResponseBlock)(NSString* filePath, NSError *error);

typedef void (^CSHttpServiceProgressBlock)(float progress);


@protocol CSHttpTask <NSObject>

- (BOOL)isLoading;

- (void)cancel;

- (BOOL)isDownload;

- (NSURL* _Nonnull)requestURL;

@end



/*
 HTTP 服务接口
 */
@protocol CSHttpService <CSService>

- (id<CSHttpTask>)request:(id<CSHttpRequest> _Nonnull)request
  responseClass:(Class _Nonnull)resClass
  responseBlock:(CSHttpServiceResponseBlock _Nonnull)responseBlock;


- (id<CSHttpTask>)requestWithURL:(NSURL* _Nonnull)url
                method:(CSHTTPMethod)method
                params:(NSDictionary<NSString*, NSObject*>* _Nullable)params
               headers:(NSDictionary<NSString*, NSString*>* _Nullable)headers
         responseBlock:(CSHttpServiceResponseDataBlock _Nonnull) responseBlock;


- (id<CSHttpTask>)downloadWithURL:(NSURL* _Nonnull)url
          responseBlock:(CSHttpServiceDownloadResponseBlock _Nonnull)downloadResponseBlock
               progress:(CSHttpServiceProgressBlock _Nullable)progressBlock;

@end
