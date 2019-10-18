//
//  SimpleAFHttpServiceRequest.h
//  CSHttpServiceAFNetworking
//
//  Created by wuyunhai on 2019/10/18.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CSHttpServiceAPI/CSHttpAbstractRequest.h>

@interface SimpleAFHttpServiceRequest : CSHttpAbstractRequest

@property (nonatomic, copy) NSURL *reqURL;

@property (nonatomic, copy) NSDictionary *reqHeaders;

@property (nonatomic, copy) NSDictionary *reqParams;

@property (nonatomic, assign) CSHTTPMethod reqHttpMethod;

@property (nonatomic, assign) int reqTimeout;

@end
