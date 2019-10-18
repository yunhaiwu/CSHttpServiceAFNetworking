//
//  CSRuntimeTool.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSRuntimeTool.h"

@implementation CSRuntimeTool

+ (void)swizzleClassMethodWithClass:(Class)clazz orginalMethod:(SEL)origSelector replaceMethod:(SEL)replSelector {
    Method origMethod = class_getClassMethod(clazz, origSelector);
    Method replMeathod = class_getClassMethod(clazz, replSelector);
    Class metaClazz = objc_getMetaClass([NSStringFromClass(clazz) UTF8String]);
    BOOL addMethodResult = class_addMethod(metaClazz, origSelector, method_getImplementation(replMeathod), method_getTypeEncoding(replMeathod));
    if (addMethodResult) {
        class_replaceMethod(metaClazz, replSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else {
        method_exchangeImplementations(origMethod, replMeathod);
    }
}

+ (void)swizzleInstanceMethodWithClass:(Class)clazz orginalMethod:(SEL)origSelector replaceMethod:(SEL)replSelector {
    Method origMethod = class_getInstanceMethod(clazz, origSelector);
    Method replMeathod = class_getInstanceMethod(clazz, replSelector);
    BOOL addMethodResult = class_addMethod(clazz, origSelector, method_getImplementation(replMeathod), method_getTypeEncoding(replMeathod));
    if (addMethodResult) {
        class_replaceMethod(clazz, replSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else {
        method_exchangeImplementations(origMethod, replMeathod);
    }
}

@end
