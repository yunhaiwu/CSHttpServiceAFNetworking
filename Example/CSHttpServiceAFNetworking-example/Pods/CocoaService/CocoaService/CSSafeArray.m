//
//  CSSafeArray.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSSafeArray.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSSafeArray ()

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation CSSafeArray

- (instancetype)init {
    self = [super init];
    if (self) {
        self.data = [[NSMutableArray alloc] init];
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

- (NSArray*)origDataCopy {
    NSArray *result = nil;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    result = [_data copy];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (id)objectAtIndex:(NSUInteger)index {
    id result = nil;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (index < [_data count]) result = [_data objectAtIndex:index];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (void)addObject:(id)anObject {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (anObject) [_data addObject:anObject];
    dispatch_semaphore_signal(_semaphore);
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (anObject && index < [_data count]) [_data insertObject:anObject atIndex:index];
    dispatch_semaphore_signal(_semaphore);
}

- (void)removeLastObject {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    [_data removeLastObject];
    dispatch_semaphore_signal(_semaphore);
}

- (void)removeObject:(id)anObject {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    [_data removeObject:anObject];
    dispatch_semaphore_signal(_semaphore);
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (index < [_data count]) [_data removeObjectAtIndex:index];
    dispatch_semaphore_signal(_semaphore);
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (index < [_data count] && anObject) [_data replaceObjectAtIndex:index withObject:anObject];
    dispatch_semaphore_signal(_semaphore);
}

@end

NS_ASSUME_NONNULL_END
