//
//  CSHttpResponseBuilder.m
//  CocoaService-HttpService-example
//
//  Created by wuyunhai on 2019/10/29.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import "CSHttpResponseBuilder.h"
#import "CSHttpAbstractResponse.h"

@interface CSHttpResponseDataParseErrorResponse : CSHttpAbstractResponse

@end

@implementation CSHttpResponseDataParseErrorResponse

- (BOOL)isError {
    return YES;
}

- (NSString *)errorCode {
    return @"-10000";
}

- (NSString *)errorMessage {
    return @"数据解析错误~";
}

@end

@implementation CSHttpResponseBuilder

+ (id<CSHttpResponse>)buildResponseWithData:(NSData *)responseData responseClass:(Class<CSHttpResponse>)responseClass {
    id<CSHttpResponse> response = nil;
    @try {
        response = [responseClass buildResponseWithData:responseData];
    } @catch (NSException *exception) {
        response = [[CSHttpResponseDataParseErrorResponse alloc] init];
    } @finally {
        [response setResponseData:responseData];
    }
    return response;
}

@end
