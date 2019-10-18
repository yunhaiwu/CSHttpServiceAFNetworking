//
//  SimpleAFHttpServiceResponse.m
//  CSHttpServiceAFNetworking-example
//
//  Created by wuyunhai on 2019/10/18.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import "SimpleAFHttpServiceResponse.h"

@implementation SimpleAFHttpServiceResponse

+ (id<CSHttpResponse>)buildResponseWithData:(NSData *)responseData {
    return [[SimpleAFHttpServiceResponse alloc] init];
}

@end
