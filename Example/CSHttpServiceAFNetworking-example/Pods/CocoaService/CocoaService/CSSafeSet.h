//
//  CSSafeSet.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 线程安全NSMutableSet封装
 */
@interface CSSafeSet<__covariant ObjectType> : NSObject

- (NSSet<ObjectType>*)origDataCopy;

- (NSUInteger)count;

- (BOOL)isEmpty;

- (void)addObject:(ObjectType)object;

- (void)removeObject:(ObjectType)object;

- (void)addObjectsFromArray:(NSArray<ObjectType> *)array;

- (void)intersectSet:(NSSet<ObjectType> *)otherSet;

- (void)minusSet:(NSSet<ObjectType> *)otherSet;

- (void)unionSet:(NSSet<ObjectType> *)otherSet;

- (void)removeAllObjects;

- (NSArray<ObjectType>*)allObjects;

- (ObjectType)anyObject;

- (BOOL)containsObject:(ObjectType)anObject;

- (BOOL)intersectsSet:(NSSet<ObjectType> *)otherSet;

- (BOOL)isEqualToSet:(NSSet<ObjectType> *)otherSet;

- (BOOL)isSubsetOfSet:(NSSet<ObjectType> *)otherSet;

@end

NS_ASSUME_NONNULL_END
