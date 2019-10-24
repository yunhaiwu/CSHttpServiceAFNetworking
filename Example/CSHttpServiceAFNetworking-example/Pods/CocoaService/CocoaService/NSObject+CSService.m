//
//  NSObject+CSService.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "NSObject+CSService.h"
#import "CSMacroDefines.h"

@implementation NSObject (CSService)

+ (BOOL)hasSingleton {
    return NO;
}

+ (NSString*)serviceId {
    return NSStringFromClass(self);
}

+ (NSString*)belongModuleId {
    return CSApplicationCoreModuleId;
}

@end
