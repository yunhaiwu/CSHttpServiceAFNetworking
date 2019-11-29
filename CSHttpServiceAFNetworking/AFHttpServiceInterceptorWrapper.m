//
//  AFHttpServiceInterceptorWrapper.m
//  CSHttpServiceAFNetworking-example
//
//  Created by wuyunhai on 2019/11/11.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import "AFHttpServiceInterceptorWrapper.h"

@implementation AFHttpServiceInterceptorWrapper

- (instancetype)initWithInterceptor:(id<CSHttpServiceInterceptor>)interceptor {
    self = [super init];
    if (self) {
        _interceptor = interceptor;
        _hasPreRequestHandle = [interceptor respondsToSelector:@selector(preRequestHandle:)];
        _hasAfterResponseHandle = [interceptor respondsToSelector:@selector(afterResponseHandle:)];
    }
    return self;
}

@end
