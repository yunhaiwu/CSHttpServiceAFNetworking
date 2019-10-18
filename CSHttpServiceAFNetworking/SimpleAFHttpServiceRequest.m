//
//  SimpleAFHttpServiceRequest.h
//  CSHttpServiceAFNetworking
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "SimpleAFHttpServiceRequest.h"

@implementation SimpleAFHttpServiceRequest

- (NSURL*)url {
    return _reqURL;
}

- (CSHTTPMethod)method {
    return _reqHttpMethod;
}

- (NSDictionary*)headers {
    return _reqHeaders;
}

- (NSDictionary*)params {
    return _reqParams;
}

- (int)timeoutDurationBySeconds {
    return _reqTimeout;
}

@end
