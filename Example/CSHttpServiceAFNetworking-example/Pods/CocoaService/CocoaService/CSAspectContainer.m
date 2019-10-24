//
//  CSAspectContainer.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSAspectContainer.h"
#import <WJLoggingAPI/WJLoggingAPI.h>
#import "CSSafeDictionary.h"
#import "CSSafeSet.h"
#import "CSApplicationPreloadDataManager.h"

@interface CSAspectContainer ()

@property (nonatomic, strong) CSSafeDictionary<NSString*, CSAspectContext*> *aspectIdToAspect;

@property (nonatomic, strong) CSSafeDictionary<NSString*, CSSafeSet<CSAspectContext*>*> *pointcutClassNameToAspectSet;

@property (nonatomic, strong) CSSafeDictionary<NSString*, CSSafeSet<NSString*>*> *moduleIdToAspectIdSet;

@property (nonatomic, assign) BOOL isExistAspects;

@end

@implementation CSAspectContainer

- (instancetype)init {
    self = [super init];
    if (self) {
        WJLogDebug(@"✅ aspect container initialize ......");
        self.aspectIdToAspect = [[CSSafeDictionary alloc] init];
        self.pointcutClassNameToAspectSet = [[CSSafeDictionary alloc] init];
        self.moduleIdToAspectIdSet = [[CSSafeDictionary alloc] init];
    }
    return self;
}

- (id)fetchServiceProxy:(id)service {
    if (_isExistAspects && service) {
        NSDictionary<NSString*, NSSet<CSAspectContext*>*> *methodToAspects = [self fetchAspects:NSStringFromClass([service class])];
        if ([methodToAspects count]) {
            return [CSAspectServiceProxy instanceProxy:service aspectFetcher:methodToAspects];
        }
    }
    return service;
}

- (void)removeAspectsByModuleId:(NSString*)moduleId {
    if (moduleId) {
        CSSafeSet<NSString*> *set = [self.moduleIdToAspectIdSet objectForKey:moduleId];
        [self removeAspectsByIds:[set origDataCopy]];
    }
}


- (NSDictionary<NSString*, NSSet<CSAspectContext*>*>*)fetchAspects:(NSString*)className {
    NSSet<CSAspectContext*> *classAspects = [[self.pointcutClassNameToAspectSet objectForKey:className] origDataCopy];
    NSSet<CSAspectContext*> *generalAspects = [[self.pointcutClassNameToAspectSet objectForKey:@"*"] origDataCopy];
    NSMutableDictionary<NSString*, NSMutableSet<CSAspectContext*>*> *methodToAspects = [[NSMutableDictionary alloc] init];
    if ([classAspects count] > 0) {
        for (CSAspectContext *a in classAspects) {
            NSSet<NSString*> *methods = [a pointcutMethods:className];
            for (NSString *m in methods) {
                NSMutableSet *s = [methodToAspects objectForKey:m];
                if (!s) {
                    s = [[NSMutableSet alloc] init];
                    [methodToAspects setObject:s forKey:m];
                }
                [s addObject:a];
            }
        }
    }
    if ([generalAspects count] > 0) {
        for (CSAspectContext *a in generalAspects) {
            NSSet<NSString*> *methods = [a pointcutMethods:className];
            for (NSString *m in methods) {
                NSMutableSet *s = [methodToAspects objectForKey:m];
                if (!s) {
                    s = [[NSMutableSet alloc] init];
                    [methodToAspects setObject:s forKey:m];
                }
                [s addObject:a];
            }
        }
    }

    return methodToAspects;
}

- (void)registerAspect:(id<CSAspectRegisterDefine>)aspectRegisterDefine {
    NSString *aspectId = [aspectRegisterDefine aspectId];
    if ([[self aspectIdToAspect] objectForKey:aspectId]) {
        WJLogDebug(@"❌ register aspect '%@' fail", aspectId);
    } else {
        CSAspectContext *aspect = [CSAspectContext buildContext:aspectRegisterDefine];
        if ([aspect options] != CSAopAspectActionOptionNone) {
            NSString *moduleId = [aspect belongModuleId];
            NSSet<NSString*> *pointcutClassNames = [aspect pointcutClassNames];
            if ([pointcutClassNames count] > 0) {
                [self.aspectIdToAspect setObject:aspect forKey:aspectId];
                
                CSSafeSet<NSString*> *aspectIdSet = [self.moduleIdToAspectIdSet objectForKey:moduleId];
                if (!aspectIdSet) {
                    aspectIdSet = [[CSSafeSet alloc] init];
                    [self.moduleIdToAspectIdSet setObject:aspectIdSet forKey:moduleId];
                }
                [aspectIdSet addObject:aspectId];
                
                for (NSString *clsName in pointcutClassNames) {
                    CSSafeSet<CSAspectContext*> *set = [self.pointcutClassNameToAspectSet objectForKey:clsName];
                    if (!set) {
                        set = [[CSSafeSet alloc] init];
                        [self.pointcutClassNameToAspectSet setObject:set forKey:clsName];
                    }
                    [set addObject:aspect];
                }
                WJLogDebug(@"✅ register aspect '%@' successful", aspectId);
            }
        }
    }
    _isExistAspects = [self.aspectIdToAspect count];
}

- (void)batchRegisterAspects:(NSSet<id<CSAspectRegisterDefine>>*)aspectRegisterDefineSet {
    NSEnumerator *enumerator = [aspectRegisterDefineSet objectEnumerator];
    id<CSAspectRegisterDefine> define = nil;
    while (define = [enumerator nextObject]) {
        [self registerAspect:define];
    }
}

- (void)removeAspectsByIds:(NSSet<NSString*>*)aspectIds {
    for (NSString *aspectId in aspectIds) {
        CSAspectContext *aspect = [self.aspectIdToAspect objectForKey:aspectId];
        NSSet<NSString*> *pointcutClassNames = [aspect pointcutClassNames];
        for (NSString *clsName in pointcutClassNames) {
            CSSafeSet<CSAspectContext*> *set = [self.pointcutClassNameToAspectSet objectForKey:clsName];
            [set removeObject:aspect];
            if ([set count] == 0) [self.pointcutClassNameToAspectSet removeObjectForKey:clsName];
        }
        [self.aspectIdToAspect removeObjectForKey:aspectId];
        WJLogDebug(@"✅ unregister aspect '%@' successful", aspectId);
    }
    _isExistAspects = [self.aspectIdToAspect count];
}


#pragma mark CSApplicationPlugin
+ (id<CSApplicationPlugin>)sharedPlugin {
    return [CSAspectContainer new];
}

- (void)applicationContext:(id<CSApplicationContext>)applicationContext moduleWillLoad:(id<CSModuleContext>)moduleContext {
    NSSet<id<CSAspectRegisterDefine>>* aspectDefines = [[CSApplicationPreloadDataManager sharedInstance] getAspectRegisterDefineSet:[moduleContext moduleId]];
    if ([aspectDefines count]) {
        [self batchRegisterAspects:aspectDefines];
    }
}

- (void)applicationContext:(id<CSApplicationContext>)applicationContext moduleDidDestroy:(id<CSModuleContext>)moduleContext {
    [self removeAspectsByModuleId:[moduleContext moduleId]];
}

@end
