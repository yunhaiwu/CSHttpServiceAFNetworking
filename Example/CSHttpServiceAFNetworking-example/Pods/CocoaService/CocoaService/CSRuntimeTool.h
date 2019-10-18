//
//  CSRuntimeTool.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSRuntimeTool : NSObject

+ (void)swizzleClassMethodWithClass:(Class)clazz orginalMethod:(SEL)origSelector replaceMethod:(SEL)replSelector;

+ (void)swizzleInstanceMethodWithClass:(Class)clazz orginalMethod:(SEL)origSelector replaceMethod:(SEL)replSelector;

@end

NS_ASSUME_NONNULL_END
