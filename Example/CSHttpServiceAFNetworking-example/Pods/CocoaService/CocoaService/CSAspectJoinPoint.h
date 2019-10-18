//
//  CSAspectJoinPoint.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CSAspectJoinPoint <NSObject>

/**
 方法名称
 */
- (SEL)aopSelector;

/**
 拦截目标
 */
- (id)aopTarget;

/**
 参数个数
 */
- (NSUInteger)numberOfArguments;

/**
 获取参数方法
 */
- (void)getArgument:(void *)argumentLocation atIndex:(NSInteger)idx;

@end







@protocol CSAspectProceedingJoinPoint <CSAspectJoinPoint>

/**
 重置参数方法
 */
- (void)setArgument:(void *)argumentLocation atIndex:(NSInteger)idx;

/**
 以原有方法继续执行
 */
- (void)proceed;

/**
 是否已执行
 */
- (BOOL)isPerformed;

@end
