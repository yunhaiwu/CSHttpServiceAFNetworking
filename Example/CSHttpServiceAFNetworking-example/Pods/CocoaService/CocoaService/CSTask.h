//
//  CSTask.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSTask <NSObject>

/**
 是否异步任务
 */
- (BOOL)isAsync;

/**
 触发任务
 */
- (void)trigger;


@end
