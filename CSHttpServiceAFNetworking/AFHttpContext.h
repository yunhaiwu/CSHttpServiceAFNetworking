//
//  AFHttpContext.h
//  CSHttpServiceAFNetworking-example
//
//  Created by wuyunhai on 2019/11/29.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CSHttpServiceAPI/CSHttpServiceAPI.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFHttpContext : NSObject<CSHttpContext>

@property (nonatomic, strong) id<CSHttpRequest> _Nullable request;

@property (nonatomic, strong) id<CSHttpResponse> _Nullable response;

@property (nonatomic, copy) CSHttpServiceResponseBlock _Nullable responseBlock;

- (instancetype)initWithRequest:(id<CSHttpRequest>)request;

@end

NS_ASSUME_NONNULL_END
