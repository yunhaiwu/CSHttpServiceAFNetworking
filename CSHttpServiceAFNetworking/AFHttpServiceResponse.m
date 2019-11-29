//
//  AFHttpServiceResponse.m
//  CSHttpServiceAFNetworking
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "AFHttpServiceResponse.h"

@implementation AFHttpServiceResponse

+ (id<CSHttpResponse>)buildResponseWithData:(NSData *)responseData {
    return [[AFHttpServiceResponse alloc] init];
}

@end
