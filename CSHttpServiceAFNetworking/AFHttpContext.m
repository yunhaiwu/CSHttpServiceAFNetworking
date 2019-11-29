//
//  AFHttpContext.m
//  CSHttpServiceAFNetworking-example
//
//  Created by wuyunhai on 2019/11/29.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import "AFHttpContext.h"

@implementation AFHttpContext

- (instancetype)initWithRequest:(id<CSHttpRequest>)request {
    self = [super init];
    if (self) {
        _request = request;
    }
    return self;
}

#pragma mark CSHttpContext
- (id<CSHttpRequest>)httpRequest {
    return _request;
}

- (id<CSHttpResponse>)httpResponse {
    return _response;
}


@end
