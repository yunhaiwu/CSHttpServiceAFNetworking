//
//  CSMonitorTimeProfiler.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSMonitorTimeProfiler.h"

@interface CSTimeProfileItem : NSObject

/*
 名称
 */
@property (nonatomic, copy) NSString *name;

/*
 开始时间
 */
@property (nonatomic, assign) double beginTime;

/*
 时长
 */
@property (nonatomic, assign) double duration;

/*
 是否为临时统计项
 */
@property (nonatomic, assign) BOOL isTemp;

/*
 此项统计已结束
 */
@property (nonatomic, assign) BOOL isDone;


@end

@implementation CSTimeProfileItem

- (void)beginTimeAction:(double)time {
    if (!_isDone) {
        _beginTime = time;
    }
}

- (void)cumulativeTimeAction:(double)time {
    if (!_isDone) {
        _duration += time - _beginTime;
        _beginTime = time;
    }
}

- (void)endTimeAction:(double)time {
    if (!_isDone) {
        _isDone = YES;
        if (_beginTime > 0.0f) {
            _duration += (time - _beginTime);
        } else {
            _beginTime = time;
            _duration = 0.0f;
        }
    }
}

- (instancetype)initWithName:(NSString*)name isTemp:(BOOL)isTemp {
    self = [super init];
    if (self) {
        self.isTemp = isTemp;
        self.name = name;
    }
    return self;
}

@end




@interface CSMonitorTimeProfiler ()

@property (nonatomic, strong) NSMutableDictionary<NSString*, CSTimeProfileItem*> *timeProfileItems;

@end

@implementation CSMonitorTimeProfiler

- (instancetype)init {
    self = [super init];
    if (self) {
        _timeProfileItems = [[NSMutableDictionary alloc] init];
        _recorder_queue = dispatch_queue_create("com.cocoaservice.monitor.time.profiler.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (CSTimeProfileItem*)getTimeItem:(NSString*)name isTemp:(BOOL)isTemp {
    CSTimeProfileItem *item = self.timeProfileItems[name];
    if (!item) {
        item = [[CSTimeProfileItem alloc] initWithName:name isTemp:isTemp];
        self.timeProfileItems[name] = item;
    }
    return item;
}

- (CSTimeProfileItem*)getTimeItem:(NSString*)name {
    CSTimeProfileItem *item = self.timeProfileItems[name];
    if (!item) {
        item = [[CSTimeProfileItem alloc] initWithName:name isTemp:NO];
        self.timeProfileItems[name] = item;
    }
    return item;
}


- (void)beginTime:(NSString*)name {
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    dispatch_async(_recorder_queue, ^{
        CSTimeProfileItem *time = [self getTimeItem:name];
        [time beginTimeAction:currentTime];
    });
}

- (void)beginTempTime:(NSString*)name {
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    dispatch_async(_recorder_queue, ^{
        CSTimeProfileItem *time = [self getTimeItem:name isTemp:YES];
        [time beginTimeAction:currentTime];
    });
}

- (void)cumulativeTime:(NSString*)name {
    CFAbsoluteTime current = CFAbsoluteTimeGetCurrent();
    dispatch_async(_recorder_queue, ^{
        CSTimeProfileItem *time = [self getTimeItem:name];
        [time cumulativeTimeAction:current];
    });
}

- (void)endTime:(NSString*)name {
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    dispatch_async(_recorder_queue, ^{
        CSTimeProfileItem *time = [self getTimeItem:name];
        [time endTimeAction:currentTime];
    });
}

- (void)getTimeDurationForSeconds:(NSString*)name isDone:(BOOL)isDone resultBlock:(void(^)(double duration, NSString *log))callbackBlock {
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    dispatch_async(_recorder_queue, ^{
        CSTimeProfileItem *time = [self getTimeItem:name];
        if (![time isDone] && isDone) {
            if (isDone) {
                [time endTimeAction:currentTime];
            }
        }
        if ([time isTemp] && [time isDone]) {
            [self.timeProfileItems removeObjectForKey:[time name]];
        }
        if (callbackBlock) {
            callbackBlock([time duration], [NSString stringWithFormat:@"⏰ %@ : %@ seconds...", [time name], @([time duration])]);
        }
    });
}

- (void)getTimeDurationForMilliseconds:(NSString*)name isDone:(BOOL)isDone resultBlock:(void(^)(double duration, NSString *log))callbackBlock {
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    dispatch_async(_recorder_queue, ^{
        CSTimeProfileItem *time = [self getTimeItem:name];
        if (![time isDone] && isDone) {
            if (isDone) {
                [time endTimeAction:currentTime];
            }
        }
        if ([time isTemp] && [time isDone]) {
            [self.timeProfileItems removeObjectForKey:[time name]];
        }
        if (callbackBlock) {
            callbackBlock([time duration] * 1000.0f, [NSString stringWithFormat:@"⏰ %@ : %@ milliseconds... \n", [time name], @([time duration] * 1000.0f)]);
        }
    });
}

- (void)getTimeProfiles:(NSArray<NSString*>*)names callbackBlock:(void(^)(NSDictionary *timeProfiles))callbackBlock {
    dispatch_async(_recorder_queue, ^{
        NSMutableDictionary *timeProfiles = [[NSMutableDictionary alloc] init];
        for (NSString *name in names) {
            CSTimeProfileItem *item = [self getTimeItem:name];
            [timeProfiles setObject:[NSString stringWithFormat:@"%@ milliseconds ...", @([item duration]*1000.0f)] forKey:name];
        }
        callbackBlock(timeProfiles);
    });
}

@end
