//
//  CSHttpResponseBuilder.h
//  CocoaService-HttpService-example
//
//  Created by wuyunhai on 2019/10/29.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSHttpResponse.h"

@interface CSHttpResponseBuilder : NSObject

+ (id<CSHttpResponse> _Nonnull)buildResponseWithData:(NSData* _Nonnull)responseData responseClass:(Class<CSHttpResponse> _Nonnull)responseClass;

@end
