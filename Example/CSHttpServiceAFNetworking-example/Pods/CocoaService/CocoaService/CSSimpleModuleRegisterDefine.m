//
//  CSSimpleModuleRegisterDefine.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSSimpleModuleRegisterDefine.h"
#import <WJLoggingAPI/WJLoggingAPI.h>

@interface CSSimpleModuleRegisterDefine ()

@property (nonatomic, assign) Class<CSModule> moduleClass;

@end

@implementation CSSimpleModuleRegisterDefine

- (instancetype)initWithModClass:(Class<CSModule>)modClass {
    self = [super init];
    if (self) {
        self.moduleClass = modClass;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        if (self.moduleClass == [object moduleClass]) {
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)hash {
    return [self.moduleClass hash];
}

+ (CSSimpleModuleRegisterDefine *)buildDefine:(Class<CSModule>)modClass {
    CSSimpleModuleRegisterDefine *define = nil;
    if ([modClass conformsToProtocol:@protocol(CSModule)]) {
        define = [[CSSimpleModuleRegisterDefine alloc] initWithModClass:modClass];
    } else {
        WJLogError(@"❌ module build fail, class '%@' not implementation 'CSModule' protocol", NSStringFromClass(modClass));
    }
    return define;
}

#pragma mark CSModuleRegisterDefine
- (NSString *)moduleId {
    return [_moduleClass moduleId];
}

- (NSUInteger)modulePriority {
    return [_moduleClass modulePriority];
}

- (CSModuleLoadingMode)moduleLoadingMode {
    return [_moduleClass moduleLoadingMode];
}

- (Class<CSModule>)moduleClass {
    return _moduleClass;
}

@end
