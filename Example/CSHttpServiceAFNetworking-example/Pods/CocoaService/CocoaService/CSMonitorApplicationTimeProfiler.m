//
//  CSMonitorApplicationTimeProfiler.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSMonitorApplicationTimeProfiler.h"
#import "CSMonitorContext.h"
#import <WJLoggingAPI/WJLoggingAPI.h>

#ifdef DEBUG
    #ifndef CS_MONITOR_WARN_THRESHOLD
        //模块加载时间监控阈值（毫秒）超过则会有警告日志
        #define CS_MONITOR_WARN_THRESHOLD    100.0f
    #endif
#endif

@interface CSMontorAppPhaseTimeProfile : NSObject

@property (nonatomic, weak) CSMonitorTimeProfiler *timeProfiler;

@property (nonatomic, copy) NSString *timeProfileKey;

@property (nonatomic, copy) NSString *describe;

//毫秒
@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, strong) NSMutableArray<CSMontorAppPhaseTimeProfile*> *subPhases;

@property (nonatomic, assign, readonly) BOOL isEnd;

@end

@implementation CSMontorAppPhaseTimeProfile

- (instancetype)initWithTimeProfileKey:(NSString*)timeProfileKey describe:(NSString*)describe timeProfiler:(CSMonitorTimeProfiler*)timeProfiler {
    self = [super init];
    if (self) {
        _timeProfiler = timeProfiler;
        self.timeProfileKey = timeProfileKey;
        self.describe = describe;
    }
    return self;
}

- (NSMutableArray<CSMontorAppPhaseTimeProfile *> *)subPhases {
    if (!_subPhases) {
        _subPhases = [[NSMutableArray alloc] init];
    }
    return _subPhases;
}

- (BOOL)isExistSubPhases {
    return [_subPhases count];
}

- (void)begin {
    if (_isEnd) return;
    [_timeProfiler beginTime:_timeProfileKey];
}

- (void)end {
    if (_isEnd) return;
    [_timeProfiler endTime:_timeProfileKey];
    _isEnd = YES;
}

- (void)cumulative {
    if (_isEnd) return;
    [_timeProfiler cumulativeTime:_timeProfileKey];
}

- (NSDictionary*)getKeyToDurations {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[_timeProfileKey] = @(_duration);
    if ([self isExistSubPhases]) {
        for (CSMontorAppPhaseTimeProfile *phase in _subPhases) {
            NSDictionary *dict = [phase getKeyToDurations];
            if ([dict count]) [result addEntriesFromDictionary:dict];
        }
    }
    return result;
}

- (NSArray<NSString*>*)getTimeProfileLog:(NSString*)prefix {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:[NSString stringWithFormat:@"%@%@ : %@ milliseconds",prefix, _describe, @(_duration)]];
    if ([self isExistSubPhases]) {
        NSString *subPrefix = [NSString stringWithFormat:@"%@\t", prefix];
        for (CSMontorAppPhaseTimeProfile *phase in _subPhases) {
            NSArray *array = [phase getTimeProfileLog:subPrefix];
            if ([array count]) [result addObjectsFromArray:array];
        }
    }
    return result;
}

@end


@interface CSMonitorApplicationTimeProfiler ()

@property (nonatomic, weak) CSMonitorTimeProfiler *timeProfiler;

@property (nonatomic, strong) NSHashTable<CSMontorAppPhaseTimeProfile*> *allTimeProfiles;

@property (nonatomic, strong) NSMutableArray<CSMontorAppPhaseTimeProfile*> *appPhaseTimeProfiles;

@property (nonatomic, weak) CSMontorAppPhaseTimeProfile *appLaunchedTimeProfile;

@property (nonatomic, weak) CSMontorAppPhaseTimeProfile *appInstantModuleLoadTimeProfile;

@property (nonatomic, weak) CSMontorAppPhaseTimeProfile *appLaunchedAfterModuleLoadTimeProfile;

@property (nonatomic, weak) CSMontorAppPhaseTimeProfile *appDataPreloadTimeProfile;

@property (nonatomic, weak) CSMontorAppPhaseTimeProfile *annotationReadTimeProfile;

@property (atomic, assign) BOOL finished;

@end

@implementation CSMonitorApplicationTimeProfiler

- (instancetype)initWithTimeProfiler:(CSMonitorTimeProfiler*)timeProfiler {
    self = [super init];
    if (self) {
        self.allTimeProfiles = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:10];
        self.timeProfiler = timeProfiler;
        self.appPhaseTimeProfiles = [[NSMutableArray alloc] initWithCapacity:3];
        CSMontorAppPhaseTimeProfile *annotationReadTimeProfile = [[CSMontorAppPhaseTimeProfile alloc] initWithTimeProfileKey:@"annotationRead" describe:@"annotation parsing time" timeProfiler:timeProfiler];
        [self.appPhaseTimeProfiles addObject:annotationReadTimeProfile];
        _annotationReadTimeProfile = annotationReadTimeProfile;
        [_allTimeProfiles addObject:annotationReadTimeProfile];
        
        CSMontorAppPhaseTimeProfile *appLaunchedTimeProfile = [[CSMontorAppPhaseTimeProfile alloc] initWithTimeProfileKey:@"appLaunched" describe:@"application launched total time" timeProfiler:timeProfiler];
        [self.appPhaseTimeProfiles addObject:appLaunchedTimeProfile];
        _appLaunchedTimeProfile = appLaunchedTimeProfile;
        [_allTimeProfiles addObject:appLaunchedTimeProfile];
        CSMontorAppPhaseTimeProfile *appDataPreloadTimeProfile = [[CSMontorAppPhaseTimeProfile alloc] initWithTimeProfileKey:@"preloadDataHandle" describe:@"preload data handle time" timeProfiler:timeProfiler];
        [[appLaunchedTimeProfile subPhases] addObject:appDataPreloadTimeProfile];
        _appDataPreloadTimeProfile = appDataPreloadTimeProfile;
        [_allTimeProfiles addObject:appDataPreloadTimeProfile];
        CSMontorAppPhaseTimeProfile *appInstantModuleLoadTimeProfile = [[CSMontorAppPhaseTimeProfile alloc] initWithTimeProfileKey:@"instantModuleLoading" describe:@"instant modules loading time" timeProfiler:timeProfiler];
        [[appLaunchedTimeProfile subPhases] addObject:appInstantModuleLoadTimeProfile];
        _appInstantModuleLoadTimeProfile = appInstantModuleLoadTimeProfile;
        [_allTimeProfiles addObject:appInstantModuleLoadTimeProfile];
        
        CSMontorAppPhaseTimeProfile *appLaunchedAfterModuleLoadTimeProfile = [[CSMontorAppPhaseTimeProfile alloc] initWithTimeProfileKey:@"launchedAfterModuleLoading" describe:@"launched after modules loading time" timeProfiler:timeProfiler];
        [self.appPhaseTimeProfiles addObject:appLaunchedAfterModuleLoadTimeProfile];
        _appLaunchedAfterModuleLoadTimeProfile = appLaunchedAfterModuleLoadTimeProfile;
        [_allTimeProfiles addObject:appLaunchedAfterModuleLoadTimeProfile];
    }
    return self;
}

- (void)beginApplicationLaunched {
    [_appLaunchedTimeProfile begin];
}

- (void)endApplicationLaunched {
    [_appLaunchedTimeProfile end];
}

- (void)beginModuleLoading:(NSString*)moduleId {
    NSString *moduleTimeProfileKey = [NSString stringWithFormat:@"%@Loading", moduleId];
    if ([_appLaunchedTimeProfile isEnd]) {
        if ([_appLaunchedAfterModuleLoadTimeProfile isEnd]) {
            [_timeProfiler beginTime:moduleTimeProfileKey];
        } else {
            CSMontorAppPhaseTimeProfile *moduleTimeProfile = [[CSMontorAppPhaseTimeProfile alloc] initWithTimeProfileKey:moduleTimeProfileKey describe:[NSString stringWithFormat:@"'%@' module loading time", moduleId] timeProfiler:_timeProfiler];
            [[_appLaunchedAfterModuleLoadTimeProfile subPhases] addObject:moduleTimeProfile];
            [moduleTimeProfile begin];
            [_allTimeProfiles addObject:moduleTimeProfile];
        }
    } else {
        CSMontorAppPhaseTimeProfile *moduleTimeProfile = [[CSMontorAppPhaseTimeProfile alloc] initWithTimeProfileKey:moduleTimeProfileKey describe:[NSString stringWithFormat:@"'%@' module loading time", moduleId] timeProfiler:_timeProfiler];
        [[_appInstantModuleLoadTimeProfile subPhases] addObject:moduleTimeProfile];
        [moduleTimeProfile begin];
        [_allTimeProfiles addObject:moduleTimeProfile];
    }
}

- (void)endModuleLoading:(NSString*)moduleId {
    if ([_appLaunchedTimeProfile isEnd]) {
        if ([_appLaunchedAfterModuleLoadTimeProfile isEnd]) {
            NSString *moduleTimeProfileKey = [NSString stringWithFormat:@"%@Loading", moduleId];
            [_timeProfiler endTime:moduleTimeProfileKey];
            [_timeProfiler getTimeDurationLogForMilliseconds:moduleTimeProfileKey isRemove:YES callback:^(double duration, NSString * _Nullable log) {
                WJLogDebug(log);
            }];
        } else {
            CSMontorAppPhaseTimeProfile *moduleTimeProfile = [[_appLaunchedAfterModuleLoadTimeProfile subPhases] lastObject];
            [moduleTimeProfile end];
        }
    } else {
        CSMontorAppPhaseTimeProfile *moduleTimeProfile = [[_appInstantModuleLoadTimeProfile subPhases] lastObject];
        [moduleTimeProfile end];
    }
}

- (void)beginApplicationInstantModulesLoading {
    [_appInstantModuleLoadTimeProfile begin];
}

- (void)endApplicationInstantModulesLoading {
    [_appInstantModuleLoadTimeProfile cumulative];
}

- (void)beginApplicationLaunchedAfterModulesLoading {
    [_appLaunchedAfterModuleLoadTimeProfile begin];
}

- (void)endApplicationLaunchedAfterModulesLoading {
    [_appLaunchedAfterModuleLoadTimeProfile end];
    _finished = YES;
}

- (void)beginApplicationDataPreload {
    [_appDataPreloadTimeProfile begin];
}

- (void)endApplicationDataPreload {
    [_appDataPreloadTimeProfile end];
}

- (void)beginAnnotationRead {
    [_annotationReadTimeProfile begin];
}

- (void)endAnnotationRead {
    [_annotationReadTimeProfile cumulative];
}

- (void)syncDurations {
    if (_finished) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSMutableSet *keys = [[NSMutableSet alloc] initWithCapacity:_allTimeProfiles.count];
            for (CSMontorAppPhaseTimeProfile *tp in _allTimeProfiles) {
                [keys addObject:[tp timeProfileKey]];
            }
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [_timeProfiler getTimeDurationsForMilliseconds:keys.allObjects isRemove:YES callback:^(NSDictionary<NSString *,NSNumber *> * _Nullable keysToDurations) {
                for (CSMontorAppPhaseTimeProfile *tp in self.allTimeProfiles) {
                    tp.duration = [keysToDurations[tp.timeProfileKey] doubleValue];
#ifdef DEBUG
                    if (tp.duration > CS_MONITOR_WARN_THRESHOLD) {
                        WJLogWarn(@"⚠️ %@ %@ milliseconds more than threshold %@ milliseconds", tp.describe, @(tp.duration), @(CS_MONITOR_WARN_THRESHOLD));
                    }
#endif
                }
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
    }
}
- (void)getApplicationTimeProfileLogReport:(void(^_Nonnull)(NSString* _Nullable logReport))callbackBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self syncDurations];
        NSMutableString *reportString = [[NSMutableString alloc] initWithString:@"\n\n==================== CocoaService Application Report. ====================\n\n"];
        NSMutableArray<NSString*> *list = [[NSMutableArray alloc] init];
        for (CSMontorAppPhaseTimeProfile *timeProfile in self.appPhaseTimeProfiles) {
            NSArray<NSString*> *a = [timeProfile getTimeProfileLog:@"\t"];
            if ([a count]) [list addObjectsFromArray:a];
        }
        for (NSString *str in list) {
            [reportString appendString:[NSString stringWithFormat:@"%@ \n", str]];
        }
        [reportString appendString:@"\n==========================================================================\n"];
        callbackBlock([reportString copy]);
    });
    
}

- (void)getApplicationTimeProfileReport:(void(^)(NSDictionary<NSString*, NSNumber*>* report))callbackBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self syncDurations];
        NSMutableDictionary *report = [[NSMutableDictionary alloc] init];
        for (CSMontorAppPhaseTimeProfile *tp in self.appPhaseTimeProfiles) {
            NSDictionary *dict = [tp getKeyToDurations];
            if ([dict count]) [report addEntriesFromDictionary:dict];
        }
        callbackBlock([report copy]);
    });
}

@end
