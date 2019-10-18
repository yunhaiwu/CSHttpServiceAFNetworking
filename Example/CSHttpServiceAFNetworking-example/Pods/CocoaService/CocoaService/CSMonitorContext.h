//
//  CSMonitorContext.h
//  CocoaService-Framework

//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSMonitorTimeProfiler+CocoaService.h"

/**
 应用程序监控
 */
@interface CSMonitorContext : NSObject

+ (instancetype)sharedInstance;

- (CSMonitorTimeProfiler*)timeProfiler;

@end
