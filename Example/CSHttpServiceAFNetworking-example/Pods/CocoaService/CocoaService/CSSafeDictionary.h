//
//  CSSafeDictionary.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 线程安全字典
 */
@interface CSSafeDictionary<__covariant KeyType, __covariant ObjectType> : NSObject

- (NSDictionary<KeyType ,ObjectType>*)origDataCopy;

- (NSUInteger)count;

- (BOOL)isEmpty;

- (ObjectType)objectForKey:(KeyType)key;

- (NSArray<ObjectType>*)objectsForKeys:(NSArray<KeyType>*)keys;

- (void)setObject:(ObjectType)object forKey:(KeyType)key;

- (void)removeObjectForKey:(KeyType)key;

- (void)removeObjectsForKeys:(NSArray<KeyType>*)keys;

- (void)removeAllObjects;

- (NSArray<KeyType>*)allKeys;

- (NSArray<ObjectType>*)allValues;

@end

NS_ASSUME_NONNULL_END
