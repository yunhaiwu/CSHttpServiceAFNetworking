//
//  CSMonitorContext.h
//  CocoaService-Framework

//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSMonitorTimeProfiler.h"
#import "CSMonitorApplicationTimeProfiler.h"

/**
 应用程序监控
 */
@interface CSMonitorContext : NSObject

+ (instancetype _Nonnull)sharedInstance;

@property (nonatomic, strong, readonly) CSMonitorTimeProfiler * _Nonnull timeProfiler;

@property (nonatomic, strong, readonly) CSMonitorApplicationTimeProfiler * _Nonnull applicationTimeProfiler;

@end
