//
//  CSApplicationCoreModule.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSApplicationCoreModule.h"

NSString *const CSApplicationCoreModuleId = @"CSApplicationCoreModule";

@implementation CSApplicationCoreModule

+ (NSUInteger)modulePriority {
    return WJ_MODULE_LOADING_PRIORITY_HIGH + 1;
}

+ (NSString *)moduleId {
    return CSApplicationCoreModuleId;
}

+ (CSModuleLoadingMode)moduleLoadingMode {
    return CSModuleLoadingModeInstant;
}

@end
