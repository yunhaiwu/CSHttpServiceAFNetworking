
//
//  CSSafeSet.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSSafeSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSSafeSet ()

@property (nonatomic, strong) NSMutableSet *data;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation CSSafeSet

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[NSMutableSet alloc] init];
        self.semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (NSUInteger)count {
    NSUInteger result = 0;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    result = [_data count];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (BOOL)isEmpty {
    return [self count] == 0;
}

- (NSSet *)origDataCopy {
    NSSet *result = nil;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    result = [_data copy];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (void)addObject:(id)object {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (object) [_data addObject:object];
    dispatch_semaphore_signal(_semaphore);
}

- (void)removeObject:(id)object {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (object) [_data removeObject:object];
    dispatch_semaphore_signal(_semaphore);
}

- (void)addObjectsFromArray:(NSArray *)array {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (array) [_data addObjectsFromArray:array];
    dispatch_semaphore_signal(_semaphore);
}

- (void)intersectSet:(NSSet *)otherSet {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (otherSet) [_data intersectSet:otherSet];
    dispatch_semaphore_signal(_semaphore);
}

- (void)minusSet:(NSSet *)otherSet {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (otherSet) [_data minusSet:otherSet];
    dispatch_semaphore_signal(_semaphore);
}

- (void)removeAllObjects {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    [_data removeAllObjects];
    dispatch_semaphore_signal(_semaphore);
}

- (NSArray*)allObjects {
    NSArray *result = nil;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    result = [_data allObjects];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (void)unionSet:(NSSet *)otherSet {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (otherSet) [_data unionSet:otherSet];
    dispatch_semaphore_signal(_semaphore);
}

- (id)anyObject {
    id result = nil;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    result = [_data anyObject];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (BOOL)containsObject:(id)anObject {
    BOOL result = NO;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (anObject) result = [_data containsObject:anObject];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (BOOL)intersectsSet:(NSSet *)otherSet {
    BOOL result = NO;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (otherSet) result = [_data intersectsSet:otherSet];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (BOOL)isEqualToSet:(NSSet *)otherSet {
    BOOL result = NO;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    result = [_data isEqualToSet:otherSet];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (BOOL)isSubsetOfSet:(NSSet *)otherSet {
    BOOL result = NO;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    result = [_data isSubsetOfSet:otherSet];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

@end

NS_ASSUME_NONNULL_END
