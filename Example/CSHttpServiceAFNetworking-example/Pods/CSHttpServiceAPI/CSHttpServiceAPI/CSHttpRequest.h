//
//  CSHttpRequest.h
//  CocoaService-HttpServiceAPI
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSHttpFileUploadModel.h"

typedef NS_ENUM(NSInteger, CSHTTPMethod) {
    
    CSHTTPMethodGET = 0,
    
    CSHTTPMethodPOST = 1,
    
    CSHTTPMethodPUT = 2,
    
    CSHTTPMethodDELETE = 3,
    
    CSHTTPMethodPATCH = 4,
};

@protocol CSHttpRequest <NSObject>

/**
 请求url
 */
- (NSURL* _Nonnull)url;

@optional
/**
 请求方法
 deault GET
 */
- (CSHTTPMethod)method;

/**
 请求头
 */
- (NSDictionary*_Nullable)headers;

/**
 请求参数
 */
- (NSDictionary*_Nullable)params;

/**
 超时时长(秒)
 default 30
 */
- (int)timeoutDurationBySeconds;

/**
 上传文件
 */
- (NSArray<CSHttpFileUploadModel*>*_Nullable)uploadFiles;

/**
 验证参数
 */
- (void)validateParamsByError:(NSError*_Nullable*_Nullable)error;


@end
