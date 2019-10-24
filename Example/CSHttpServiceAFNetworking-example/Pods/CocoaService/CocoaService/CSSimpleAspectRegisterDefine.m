//
//  CSSimpleAspectRegisterDefine.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSSimpleAspectRegisterDefine.h"
#import <WJLoggingAPI/WJLoggingAPI.h>
#import "CSMacroDefines.h"

@interface CSSimpleAspectRegisterDefine ()

@property (nonatomic, assign) Class aspectClass;

@property (nonatomic, copy) NSString *aspectId;

@property (nonatomic, copy) NSString *moduleId;

@end

@implementation CSSimpleAspectRegisterDefine

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        if ([self aspectClass] == [object aspectClass]) {
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)hash {
    return [_aspectClass hash];
}

- (instancetype)initWithAspectClass:(Class<CSAspect>)aspectClass {
    self = [super init];
    if (self) {
        self.aspectClass = aspectClass;
    }
    return self;
}

+ (CSSimpleAspectRegisterDefine*)buildDefine:(Class<CSAspect>)aspectClass {
    CSSimpleAspectRegisterDefine *define = nil;
    if ([aspectClass conformsToProtocol:@protocol(CSAspect)]) {
        define = [[CSSimpleAspectRegisterDefine alloc] initWithAspectClass:aspectClass];
    } else {
        WJLogError(@"❌ aspect build fail, class '%@' not implementation 'CSAspect' protocol", NSStringFromClass(aspectClass));
    }
    return define;
}

#pragma mark CSAspectRegisterDefine
- (NSString*)aspectId {
    if (!_aspectId) {
        if ([_aspectClass respondsToSelector:@selector(aspectId)]) {
            _aspectId = [[_aspectClass aspectId] copy];
        }
        if (!_aspectId) {
            _aspectId = [NSStringFromClass(_aspectClass) copy];
        }
    }
    return _aspectId;
}

- (NSString*)belongModuleId {
    if (!_moduleId) {
        if ([_aspectClass respondsToSelector:@selector(belongModuleId)]) {
            _moduleId = [[_aspectClass belongModuleId] copy];
        }
        if (!_moduleId) {
            _moduleId = CSApplicationCoreModuleId;
        }
    }
    return _moduleId;
}

- (Class)aspectClass {
    return _aspectClass;
}

@end
