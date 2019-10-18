//
//  SimpleAFHttpServiceResponse.m
//  CSHttpServiceAFNetworking
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "SimpleAFHttpServiceResponse.h"

@implementation SimpleAFHttpServiceResponse

+ (id<CSHttpResponse>)buildResponseWithData:(NSData *)responseData {
    return [[SimpleAFHttpServiceResponse alloc] init];
}

@end
