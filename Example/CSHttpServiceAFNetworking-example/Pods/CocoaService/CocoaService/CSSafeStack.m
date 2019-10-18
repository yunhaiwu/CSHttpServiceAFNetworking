//
//  CSSafeStack.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSSafeStack.h"

@interface CSSafeStack ()

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation CSSafeStack

- (instancetype)init {
    self = [super init];
    if (self) {
        self.data = [[NSMutableArray alloc] initWithCapacity:20];
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
    NSUInteger result = NO;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    result = [_data count];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (BOOL)isEmpty {
    return [self count] == 0;
}

- (void)push:(id)element {
    if (element) {
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        [_data addObject:element];
        dispatch_semaphore_signal(_semaphore);
    }
}

- (id)pop {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    id element = [_data lastObject];
    if (element) {
        [_data removeLastObject];
    }
    dispatch_semaphore_signal(_semaphore);
    return element;
}

- (id)peek {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    id element = [_data lastObject];
    dispatch_semaphore_signal(_semaphore);
    return element;
}

@end
