//
//  CSMonitorTimeProfiler.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CSMonitorTimeProfiler : NSObject

@property (nonatomic, strong, readonly) dispatch_queue_t recorder_queue;

/*
 开始统计
 */
- (void)beginTime:(NSString*)name;

/*
 开始一个临时统计（在endTime时会被删除）
 */
- (void)beginTempTime:(NSString*)name;

/*
 累加时间
 */
- (void)cumulativeTime:(NSString*)name;

/*
 结束计算统计（统计结束）
 */
- (void)endTime:(NSString*)name;

/*
 获取以秒计数的时长
 */
- (void)getTimeDurationForSeconds:(NSString*)name isDone:(BOOL)isDone resultBlock:(void(^)(double duration, NSString *log))callbackBlock;

/*
获取以毫秒计数的时长
*/
- (void)getTimeDurationForMilliseconds:(NSString*)name isDone:(BOOL)isDone resultBlock:(void(^)(double duration, NSString *log))callbackBlock;


- (void)getTimeProfiles:(NSArray<NSString*>*)names callbackBlock:(void(^)(NSDictionary *timeProfiles))callbackBlock;

@end
