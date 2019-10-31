//
//  SimpleAFHttpServiceRequest.h
//  CSHttpServiceAFNetworking
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CSHttpServiceAPI/CSHttpAbstractRequest.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleAFHttpServiceRequest : CSHttpAbstractRequest

@property (nonatomic, copy) NSURL *reqURL;

@property (nonatomic, copy) NSDictionary *reqHeaders;

@property (nonatomic, copy) NSDictionary *reqParams;

@property (nonatomic, assign) CSHTTPMethod reqHttpMethod;

@property (nonatomic, assign) int reqTimeout;

@end

NS_ASSUME_NONNULL_END
