//
//  CSSimpleApplicationPluginDefine.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSSimpleApplicationPluginDefine.h"
#import <WJLoggingAPI/WJLoggingAPI.h>

@interface CSSimpleApplicationPluginDefine ()

@property (nonatomic, assign) Class pluginClass;

@end

@implementation CSSimpleApplicationPluginDefine

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        return [object pluginClass] == [self pluginClass];
    }
    return NO;
}

- (NSUInteger)hash {
    return [_pluginClass hash];
}

- (instancetype)initWithPluginClass:(Class)clazz {
    self = [super init];
    if (self) {
        _pluginClass = clazz;
    }
    return self;
}

- (Class)pluginClass {
    return _pluginClass;
}

+ (id<CSApplicationPluginDefine>)buildDefine:(Class)clazz {
    if ([clazz conformsToProtocol:@protocol(CSApplicationPlugin)]) {
        return [[CSSimpleApplicationPluginDefine alloc] initWithPluginClass:clazz];
    } else {
        WJLogError(@"❌ application plugin define build fail, class '%@' not implementation 'CSApplicationPlugin' protocol", NSStringFromClass(clazz));
    }
    return nil;
}

@end
