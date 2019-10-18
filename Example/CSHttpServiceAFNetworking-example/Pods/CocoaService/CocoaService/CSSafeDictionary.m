//
//  CSSafeDictionary.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSSafeDictionary.h"

@interface CSSafeDictionary ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, strong) NSMutableDictionary *data;

@end

@implementation CSSafeDictionary

- (instancetype)init {
    self = [super init];
    if (self) {
        self.data = [[NSMutableDictionary alloc] init];
        self.semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (NSDictionary*)origDataCopy {
    NSDictionary *result = nil;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    result = [_data copy];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (NSUInteger)count {
    NSUInteger count = 0;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    count = [_data count];
    dispatch_semaphore_signal(_semaphore);
    return count;
}

- (BOOL)isEmpty {
    return [self count] == 0;
}

- (id)objectForKey:(id<NSCopying, NSObject>)key {
    id result = nil;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    result = _data[key];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (NSArray *)objectsForKeys:(NSArray *)keys {
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[keys count]];
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    for (id key in keys) {
        id obj = _data[key];
        if (obj) [result addObject:obj];
    }
    dispatch_semaphore_signal(_semaphore);
    if ([result count]) {
        return [result copy];
    }
    return nil;
}

- (void)setObject:(id)object forKey:(id<NSCopying, NSObject>)key {
    if (key && object) {
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        [_data setObject:object forKey:key];
        dispatch_semaphore_signal(_semaphore);
    }
}

- (void)removeObjectForKey:(id<NSCopying, NSObject>)key {
    if (key) {
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        [_data removeObjectForKey:key];
        dispatch_semaphore_signal(_semaphore);
    }
}

- (void)removeObjectsForKeys:(NSArray*)keys {
    if (keys) {
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        [_data removeObjectsForKeys:keys];
        dispatch_semaphore_signal(_semaphore);
    }
}

- (void)removeAllObjects {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    [_data removeAllObjects];
    dispatch_semaphore_signal(_semaphore);
}

- (NSArray*)allKeys {
    NSArray *keys = nil;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    keys = [_data allKeys];
    dispatch_semaphore_signal(_semaphore);
    return keys;
}

- (NSArray*)allValues {
    NSArray *values = nil;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    values = [_data allValues];
    dispatch_semaphore_signal(_semaphore);
    return values;
}

@end
