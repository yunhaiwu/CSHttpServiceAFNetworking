//
//  CSSafeQueue.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSSafeQueue.h"

@interface CSSafeQueue ()

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (atomic, assign) NSUInteger currentSize;

@end

@implementation CSSafeQueue

- (instancetype)initWithMaxSize:(NSUInteger)maxSize {
    self = [super init];
    if (self) {
        self.data = [[NSMutableArray alloc] init];
        self.semaphore = dispatch_semaphore_create(1);
        _maxSize = maxSize;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.data = [[NSMutableArray alloc] init];
        self.semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (NSArray*)origDataCopy {
    NSArray *result = nil;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    result = [_data copy];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (NSUInteger)count {
    return _currentSize;
}

- (BOOL)isEmpty {
    return [self count] == 0;
}

- (id)poll {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    id element = [_data firstObject];
    if (element) {
        [_data removeObjectAtIndex:0];
        _currentSize --;
    }
    dispatch_semaphore_signal(_semaphore);
    return element;
}

- (void)put:(id)element {
    if (element) {
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        if (_maxSize) {
            if (_currentSize == _maxSize) {
                [_data removeObjectAtIndex:0];
                [_data addObject:element];
            } else {
                [_data addObject:element];
                _currentSize ++;
            }
        } else {
            [_data addObject:element];
            _currentSize ++;
        }
        dispatch_semaphore_signal(_semaphore);
    }
}

@end
