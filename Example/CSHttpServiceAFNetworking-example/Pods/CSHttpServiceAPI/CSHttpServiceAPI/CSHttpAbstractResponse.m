//
//  CSHttpAbstractResponse.m
//  CocoaService-HttpServiceAPI
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSHttpAbstractResponse.h"

@implementation CSHttpAbstractResponse

+ (id<CSHttpResponse>)buildResponseWithData:(NSData*) responseData {
    id<CSHttpResponse> response = nil;
    if ([responseData length]) {
        response = [self buildResponseWithString:[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]];
        [response setResponseData:responseData];
    }
    return response;
}

+ (id<CSHttpResponse>)buildResponseWithString:(NSString*)responseString {
    return nil;
}

- (BOOL)isError {
    return NO;
}

- (NSString*)errorCode {
    return nil;
}

- (NSString*)errorMessage {
    return nil;
}

@end
