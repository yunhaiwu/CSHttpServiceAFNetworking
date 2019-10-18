//
//  SimpleAFHttpServiceRequest.h
//  CSHttpServiceAFNetworking
//
//  Created by wuyunhai on 2019/10/18.
//  Copyright © 2019 wuyunhai. All rights reserved.
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
