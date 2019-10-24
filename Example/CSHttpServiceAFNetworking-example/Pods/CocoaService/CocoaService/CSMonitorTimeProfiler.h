//
//  CSMonitorTimeProfiler.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSMonitorTimeProfiler : NSObject

/*
 开始
 */
- (void)beginTime:(NSString* _Nonnull)key;

/*
 累加
 */
- (void)cumulativeTime:(NSString* _Nonnull)key;

/*
 结束
 */
- (void)endTime:(NSString* _Nonnull)key;

/*
 获取时长log（秒）
 key:统计key
 isRemove：获取完成后是否移除，建议移除
 callback：回调block
 */
- (void)getTimeDurationLogForSeconds:(NSString* _Nonnull )key isRemove:(BOOL)isRemove callback:(void(^_Nonnull)(double duration, NSString * _Nullable log))callbackBlock;

/*
 获取时长log（毫秒）
 key:统计key
 isRemove：获取完成后是否移除，建议移除
 callback：回调block
*/
- (void)getTimeDurationLogForMilliseconds:(NSString* _Nonnull )key isRemove:(BOOL)isRemove callback:(void(^_Nonnull)(double duration, NSString * _Nullable log))callbackBlock;

/*
 根据keys获取时长（秒）
 keys:统计keys
 isRemove：获取完成后是否移除，建议移除
 callback：回调block
 */
- (void)getTimeDurationsForSeconds:(NSArray<NSString*>* _Nonnull)keys isRemove:(BOOL)isRemove callback:(void(^_Nonnull)(NSDictionary<NSString*, NSNumber*> * _Nullable keysToDurations))callbackBlock;

/*
根据keys获取时长（毫秒）
keys:统计keys
isRemove：获取完成后是否移除，建议移除
callback：回调block
*/
- (void)getTimeDurationsForMilliseconds:(NSArray<NSString*>* _Nonnull)keys isRemove:(BOOL)isRemove callback:(void(^_Nonnull)(NSDictionary<NSString*, NSNumber*> * _Nullable keysToDurations))callbackBlock;


@end
