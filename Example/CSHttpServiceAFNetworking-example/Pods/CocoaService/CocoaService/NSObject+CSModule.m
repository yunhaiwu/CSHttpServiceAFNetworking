//
//  NSObject+CSModule.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "NSObject+CSModule.h"
#import <objc/runtime.h>


@implementation NSObject (CSModule)

- (void)setModContext:(id<CSModuleContext>)modContext {
    objc_setAssociatedObject(self, @selector(modContext), modContext, OBJC_ASSOCIATION_ASSIGN);
}

- (id<CSModuleContext>)modContext {
    return objc_getAssociatedObject(self, @selector(modContext));
}

+ (NSString*)moduleId {
    return NSStringFromClass([self class]);
}

+ (NSUInteger)modulePriority {
    return WJ_MODULE_LOADING_PRIORITY_DEFAULT;
}

+ (CSModuleLoadingMode)moduleLoadingMode {
    return CSModuleLoadingModeLaunchedAfter;
}

@end
