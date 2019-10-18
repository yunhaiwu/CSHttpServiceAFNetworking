//
//  CSSafeQueue.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSSafeQueue<__covariant ObjectType> : NSObject

@property (nonatomic, assign, readonly) NSUInteger maxSize;

/*
 初始化方法
 maxSize：队列最大数量，如果添加时超过最大数量则移除最先添加的元素（先进先出），如果为0，则不限制大小
 */
- (instancetype)initWithMaxSize:(NSUInteger)maxSize;

- (NSArray<ObjectType>*)origDataCopy;

- (NSUInteger)count;

- (BOOL)isEmpty;

/*
 返回第一个元素并从队列中移除
 */
- (ObjectType)poll;

/*
 添加元素
 @param element 元素
 */
- (void)put:(ObjectType)element;

@end

NS_ASSUME_NONNULL_END
