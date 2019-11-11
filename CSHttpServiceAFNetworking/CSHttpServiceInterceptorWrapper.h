//
//  CSHttpServiceInterceptorWrapper.h
//  CSHttpServiceAFNetworking-example
//
//  Created by wuyunhai on 2019/11/11.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CSHttpServiceAPI/CSHttpServiceInterceptor.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSHttpServiceInterceptorWrapper : NSObject

@property (nonatomic, strong) id<CSHttpServiceInterceptor> interceptor;

@property (nonatomic, assign) BOOL hasPreRequestHandle, hasAfterResponseHandle;

- (instancetype)initWithInterceptor:(id<CSHttpServiceInterceptor>)interceptor;

@end

NS_ASSUME_NONNULL_END
