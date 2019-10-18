//
//  CSSimpleAppFristViewControllerDefine.h
//  CocoaService-example
//
//  Created by wuyunhai on 2019/10/14.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSAppFirstViewControllerDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSSimpleAppFristViewControllerDefine : NSObject<CSAppFirstViewControllerDefine>

+ (CSSimpleAppFristViewControllerDefine*)buildDefine:(Class)clazz;

@end

NS_ASSUME_NONNULL_END
