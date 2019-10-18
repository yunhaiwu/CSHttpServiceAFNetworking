//
//  CSAspectContext.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSAspectContext.h"

@interface CSAspectContext ()

@property (nonatomic, copy) NSDictionary<NSString*, NSMutableSet<NSString*>*> *pointcuts;

@property (nonatomic, strong) id<CSAspectRegisterDefine> aspectRegisterDefine;

@property (atomic, strong) id<CSAspect> aspect;

@end

@implementation CSAspectContext

+ (instancetype)buildContext:(id<CSAspectRegisterDefine>)aspectRegisterDefine {
    if ([[aspectRegisterDefine aspectClass] conformsToProtocol:@protocol(CSAspect)]) {
        return [[CSAspectContext alloc] initWithAspectDefine:aspectRegisterDefine];
    }
    return nil;
}

- (instancetype)initWithAspectDefine:(id<CSAspectRegisterDefine>)aspectRegisterDefine {
    self = [super init];
    if (self) {
        self.aspectRegisterDefine = aspectRegisterDefine;
        Class aspectClass = [aspectRegisterDefine aspectClass];
        if ([aspectClass instancesRespondToSelector:@selector(doBefore:)]) {
            _options |= CSAopAspectActionOptionBefore;
        }
        if ([aspectClass instancesRespondToSelector:@selector(doAfter:)]) {
            _options |= CSAopAspectActionOptionAfter;
        }
        if ([aspectClass instancesRespondToSelector:@selector(doAround:)]) {
            _options |= CSAopAspectActionOptionAround;
        }
        [self handlePointExpressions];
    }
    return self;
}

- (void)handlePointExpressions {
    NSMutableDictionary<NSString*, NSMutableSet<NSString*>*> *pointcuts = [[NSMutableDictionary alloc] init];
    NSString *pointcutExpressions = [self.aspect pointcutExpressions];
    NSArray<NSString*> *expressions = [pointcutExpressions componentsSeparatedByString:@";"];
    for (NSString *e in expressions) {
        NSRange range = [e rangeOfString:@"("];
        if (range.length == 1) {
            NSString *className = [e substringToIndex:range.location];
            NSString *methodName = [e substringWithRange:NSMakeRange(range.location + 1, e.length - range.location - 2)];
            NSMutableSet *methods = pointcuts[className];
            if (!methods) {
                methods = [[NSMutableSet alloc] init];
                [pointcuts setObject:methods forKey:className];
            }
            [methods addObject:methodName];
        }
    }
    self.pointcuts = pointcuts;
}

- (id<CSAspect>)aspectObject {
    if (!_aspect) {
        @synchronized (self) {
            if (!_aspect) {
                _aspect = [[[_aspectRegisterDefine aspectClass] alloc] init];
            }
        }
    }
    return _aspect;
}

- (NSSet<NSString*>*)pointcutClassNames {
    NSArray *clsList = [self.pointcuts allKeys];
    if ([clsList count] > 0) {
        return [[NSSet alloc] initWithArray:clsList];
    }
    return nil;
}

- (NSSet<NSString*>*)pointcutMethods:(NSString*)className {
    NSMutableSet *result = [[NSMutableSet alloc] init];
    NSMutableSet *generalMethods =  _pointcuts[@"*"];
    if ([generalMethods count] > 0) [result addObjectsFromArray:generalMethods.allObjects];
    NSMutableSet *classMethods = _pointcuts[className];
    if ([classMethods count] > 0) [result addObjectsFromArray:classMethods.allObjects];
    return result;
}

- (NSString *)belongModuleId {
    return [_aspectRegisterDefine belongModuleId];
}

- (NSString*)aspectId {
    return [_aspectRegisterDefine aspectId];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[CSAspectContext class]]) {
        return [[self aspectId] isEqual:[object aspectId]];
    }
    return NO;
}

- (NSUInteger)hash {
    return [[self aspectId] hash];
}

@end
