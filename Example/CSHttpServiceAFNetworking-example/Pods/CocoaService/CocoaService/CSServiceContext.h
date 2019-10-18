//
//  CSServiceContext.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSafeSet.h"
#import "CSServiceWrapper.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSServiceContext : NSObject

@property (nonatomic, strong) CSSafeSet<NSString*> *serviceIdSet;

@property (nonatomic, weak) CSServiceWrapper *defaultServiceWrapper;

- (void)addServiceId:(NSString*)serviceId;

- (instancetype)initWithServiceWrapper:(CSServiceWrapper*)wrapper;

@end

NS_ASSUME_NONNULL_END
