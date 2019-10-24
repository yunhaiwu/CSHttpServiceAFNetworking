//
//  CSTask.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

///*
// 任务类型
// */
//typedef NS_ENUM(NSInteger, CSTaskType) {
//
//    CSTaskTypeAppLaunchedAfter = 0,
//
//};

@protocol CSTask <NSObject>

/*
 是否异步任务
 */
- (BOOL)isAsync;

/*
 任务触发
 */
- (void)trigger;

@end
