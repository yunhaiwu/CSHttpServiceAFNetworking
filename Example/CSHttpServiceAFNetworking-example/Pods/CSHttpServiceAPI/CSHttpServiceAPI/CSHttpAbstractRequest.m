//
//  CSHttpAbstractRequest.m
//  CocoaService-HttpServiceAPI
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSHttpAbstractRequest.h"
#import <CocoaService/CocoaService.h>

@implementation CSHttpAbstractRequest

- (NSURL*)url {
    return nil;
}

- (CSHTTPMethod)method {
    return CSHTTPMethodGET;
}

- (NSDictionary*)headers {
    return nil;
}

- (NSDictionary*)params {
    return nil;
}

@end
