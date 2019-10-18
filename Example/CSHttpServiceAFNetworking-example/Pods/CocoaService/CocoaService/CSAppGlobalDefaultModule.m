//
//  CSAppGlobalDefaultModule.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSAppGlobalDefaultModule.h"

NSString *const CSAppGlobalDefaultModuleId = @"CSAppGlobalDefaultModule";

@implementation CSAppGlobalDefaultModule

+ (int)modulePriority {
    return WJ_MODULE_LOADING_PRIORITY_HIGH + 1;
}

+ (NSString *)moduleId {
    return CSAppGlobalDefaultModuleId;
}

+ (CSModuleLoadingMode)moduleLoadingMode {
    return CSModuleLoadingModeInstant;
}

@end
