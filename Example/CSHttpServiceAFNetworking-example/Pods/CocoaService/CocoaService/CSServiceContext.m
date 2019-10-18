//
//  CSServiceContext.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSServiceContext.h"

@implementation CSServiceContext

- (void)addServiceId:(NSString*)serviceId {
    [self.serviceIdSet addObject:serviceId];
}

- (instancetype)initWithServiceWrapper:(CSServiceWrapper*)wrapper {
    self = [super init];
    if (self) {
        self.serviceIdSet = [[CSSafeSet alloc] init];
        self.defaultServiceWrapper = wrapper;
    }
    return self;
}

@end
