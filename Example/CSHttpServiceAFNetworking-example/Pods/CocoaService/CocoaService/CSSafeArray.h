//
//  CSSafeArray.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 线程安全数组
 */
@interface CSSafeArray<__covariant ObjectType> : NSObject

- (NSUInteger)count;

- (BOOL)isEmpty;

- (NSArray<ObjectType>*)origDataCopy;

- (ObjectType)objectAtIndex:(NSUInteger)index;

- (void)addObject:(ObjectType)anObject;

- (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;

- (void)removeLastObject;

- (void)removeObject:(ObjectType)anObject;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)anObject;

@end

NS_ASSUME_NONNULL_END
