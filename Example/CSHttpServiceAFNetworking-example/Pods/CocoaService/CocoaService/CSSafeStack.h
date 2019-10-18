//
//  CSSafeStack.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 堆栈
 */
@interface CSSafeStack<__covariant ObjectType> : NSObject

/*
 源数据拷贝
 */
- (NSArray<ObjectType>*)origDataCopy;

/*
 当前栈大小
 */
- (NSUInteger)count;

/*
 是否为空
 */
- (BOOL)isEmpty;

/*
 压栈
 */
- (void)push:(ObjectType)element;

/*
返回栈顶元素，并移除
*/
- (ObjectType)pop;

/*
 返回栈顶元素，不移除
 */
- (ObjectType)peek;

@end

NS_ASSUME_NONNULL_END
