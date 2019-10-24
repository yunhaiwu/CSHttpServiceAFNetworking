//
//  CSMonitorTimeProfiler.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSMonitorTimeProfiler.h"


@interface CSTimeProfileItem : NSObject

@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) double beginTime;

@property (nonatomic, assign) double duration;

@property (nonatomic, assign) BOOL isDone;

@end

@implementation CSTimeProfileItem

- (void)begin:(double)time {
    if (!_isDone) {
        _beginTime = time;
    }
}

- (void)cumulative:(double)time {
    if (!_isDone) {
        _duration += time - _beginTime;
        _beginTime = time;
    }
}

- (void)end:(double)time {
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

- (instancetype)initWithKey:(NSString*)key {
    self = [super init];
    if (self) {
        self.key = key;
    }
    return self;
}

@end


@interface CSMonitorTimeProfiler ()

@property (nonatomic, strong, readonly) dispatch_queue_t time_prifiler_queue;

@property (nonatomic, strong) NSMutableDictionary<NSString*, CSTimeProfileItem*> *timeProfileItems;

@end

@implementation CSMonitorTimeProfiler

- (instancetype)init {
    self = [super init];
    if (self) {
        _timeProfileItems = [[NSMutableDictionary alloc] init];
        _time_prifiler_queue = dispatch_queue_create("com.cocoaservice.monitor.time.profiler.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (CSTimeProfileItem*)getTimeItem:(NSString*)key {
    CSTimeProfileItem *item = self.timeProfileItems[key];
    if (!item) {
        item = [[CSTimeProfileItem alloc] initWithKey:key];
        self.timeProfileItems[key] = item;
    }
    return item;
}

- (void)beginTime:(NSString* _Nonnull)key {
    CFAbsoluteTime current = CFAbsoluteTimeGetCurrent();
    dispatch_async(_time_prifiler_queue, ^{
        CSTimeProfileItem *time = [self getTimeItem:key];
        [time begin:current];
    });
}

- (void)cumulativeTime:(NSString* _Nonnull)key {
    CFAbsoluteTime current = CFAbsoluteTimeGetCurrent();
    dispatch_async(_time_prifiler_queue, ^{
        CSTimeProfileItem *time = [self getTimeItem:key];
        [time cumulative:current];
    });
}

- (void)endTime:(NSString* _Nonnull)key {
    CFAbsoluteTime current = CFAbsoluteTimeGetCurrent();
    dispatch_async(_time_prifiler_queue, ^{
        CSTimeProfileItem *time = [self getTimeItem:key];
        [time end:current];
    });
}

- (void)getTimeDurationLogForSeconds:(NSString *)key isRemove:(BOOL)isRemove callback:(void (^)(double, NSString * _Nonnull))callbackBlock {
    dispatch_async(_time_prifiler_queue, ^{
        CSTimeProfileItem *time = [self getTimeItem:key];
        if (isRemove) [self.timeProfileItems removeObjectForKey:key];
        if (callbackBlock) {
            callbackBlock([time duration], [NSString stringWithFormat:@"⏰ %@ : %@ seconds...", [time key], @([time duration])]);
        }
    });
}

- (void)getTimeDurationLogForMilliseconds:(NSString *)key isRemove:(BOOL)isRemove callback:(void (^)(double, NSString * _Nonnull))callbackBlock {
    dispatch_async(_time_prifiler_queue, ^{
        CSTimeProfileItem *time = [self getTimeItem:key];
        if (isRemove) [self.timeProfileItems removeObjectForKey:key];
        if (callbackBlock) {
            callbackBlock([time duration], [NSString stringWithFormat:@"⏰ %@ : %@ milliseconds...", [time key], @([time duration] * 1000.0f)]);
        }
    });
}

- (void)getTimeDurationsForSeconds:(NSArray<NSString *> *)keys isRemove:(BOOL)isRemove callback:(void (^)(NSDictionary<NSString *,NSNumber *> * _Nullable))callbackBlock {
    dispatch_async(_time_prifiler_queue, ^{
        NSMutableDictionary *keysToDurations = [[NSMutableDictionary alloc] initWithCapacity:keys.count];
        for (NSString *key in keys) {
            CSTimeProfileItem *timeProfileItem = self.timeProfileItems[key];
            if (timeProfileItem) {
                [keysToDurations setObject:@([timeProfileItem duration]) forKey:key];
            }
            if (isRemove) [self.timeProfileItems removeObjectForKey:key];
        }
        callbackBlock([keysToDurations copy]);
    });
}

- (void)getTimeDurationsForMilliseconds:(NSArray<NSString *> *)keys isRemove:(BOOL)isRemove callback:(void (^)(NSDictionary<NSString *,NSNumber *> * _Nullable))callbackBlock {
    dispatch_async(_time_prifiler_queue, ^{
        NSMutableDictionary *keysToDurations = [[NSMutableDictionary alloc] initWithCapacity:keys.count];
        for (NSString *key in keys) {
            CSTimeProfileItem *timeProfileItem = self.timeProfileItems[key];
            if (timeProfileItem) {
                [keysToDurations setObject:@([timeProfileItem duration] * 1000.0f) forKey:key];
            }
            if (isRemove) [self.timeProfileItems removeObjectForKey:key];
        }
        callbackBlock([keysToDurations copy]);
    });
}

@end
