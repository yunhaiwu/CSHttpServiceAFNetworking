//
//  CSApplicationPreloadDataManager.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSApplicationPreloadDataManager.h"
#import <WJLoggingAPI/WJLoggingAPI.h>
#import "CSAnnotation.h"
#import "CSModule.h"
#import "NSObject+CSService.h"
#import "CSSimpleModuleRegisterDefine.h"
#import "CSSimpleServiceRegisterDefine.h"
#import "CSMonitorContext.h"
#import "CSSimpleAspectRegisterDefine.h"
#import "CSSimpleApplicationPluginDefine.h"

@interface CSApplicationPreloadDataManager ()

@property (nonatomic, copy) NSDictionary<NSString*, NSMutableSet<CSSimpleAspectRegisterDefine*>*> *moduleIdToAspectDefinesDict;

@property (nonatomic, copy) NSSet<CSSimpleModuleRegisterDefine*> *moduleDefineSet;

@property (nonatomic, copy) NSDictionary<NSString*, NSDictionary<NSString*, CSSimpleServiceRegisterDefine*>*> *moduleIdToServiceDefinesDict;

@property (nonatomic, copy) NSSet<Class> *firstViewControllerClassSet;

@property (nonatomic, copy) NSSet<CSSimpleApplicationPluginDefine*> *applicationPluginDefineSet;

@end

@implementation CSApplicationPreloadDataManager

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

+ (instancetype)sharedInstance {
    static CSApplicationPreloadDataManager *sharedObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[CSApplicationPreloadDataManager alloc] init];
    });
    return sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[[CSMonitorContext sharedInstance] applicationTimeProfiler] beginApplicationDataPreload];
        [self loadAnnotationPreloadDatas];
        [[[CSMonitorContext sharedInstance] applicationTimeProfiler] endApplicationDataPreload];
    }
    return self;
}

- (void)loadAnnotationPreloadDatas {
    NSSet *annotationServiceDefines = [[CSAnnotation sharedInstance] fetchAnnotationServiceDefines];
    if ([annotationServiceDefines count] > 0) {
        NSMutableDictionary<NSString*, NSMutableDictionary<NSString*, CSSimpleServiceRegisterDefine*>*> *moduleIdToDefines = [[NSMutableDictionary alloc] init];
        for (NSString *expr in annotationServiceDefines) {
            NSString *moduleId = nil;
            Class serviceClass = nil;
            Protocol *serviceProtocol = nil;
            NSString *serviceProtocolName = nil;
            NSString *serviceClassName = nil;
            NSArray *components  = [expr componentsSeparatedByString:@":"];
            if ([components count] == 2) {
                serviceProtocolName = components[0];
                serviceClassName = components[1];
                serviceProtocol = NSProtocolFromString(serviceProtocolName);
                serviceClass = NSClassFromString(serviceClassName);
                moduleId = [serviceClass belongModuleId];
            }
            if (!moduleId) moduleId = CSApplicationCoreModuleId;
            
            if ([serviceClass conformsToProtocol:serviceProtocol]) {
                NSMutableDictionary<NSString*, CSSimpleServiceRegisterDefine*> *protocolToDefines = moduleIdToDefines[moduleId];
                if (!protocolToDefines) {
                    protocolToDefines = [[NSMutableDictionary alloc] init];
                    moduleIdToDefines[moduleId] = protocolToDefines;
                }
                CSSimpleServiceRegisterDefine *define = protocolToDefines[serviceProtocolName];
                if (define) {
                    [define appendServiceClass:serviceClass];
                } else {
                    define = [CSSimpleServiceRegisterDefine buildDefine:serviceProtocol serviceClass:serviceClass];
                    protocolToDefines[serviceProtocolName] = define;
                }
            }
        }
        self.moduleIdToServiceDefinesDict = moduleIdToDefines;
    }
    
    NSSet *annotationAspectDefines = [[CSAnnotation sharedInstance] fetchAnnotationAspectDefines];
    if ([annotationAspectDefines count] > 0) {
        NSMutableDictionary<NSString*, NSMutableSet<CSSimpleAspectRegisterDefine*>*> *moduleIdToAspectDefines = [[NSMutableDictionary alloc] init];
        for (NSString* aspectClassName in annotationAspectDefines) {
            CSSimpleAspectRegisterDefine *define = [CSSimpleAspectRegisterDefine buildDefine:NSClassFromString(aspectClassName)];
            if (define) {
                NSString *moduleId = [define belongModuleId];
                NSMutableSet<CSSimpleAspectRegisterDefine*> *set = moduleIdToAspectDefines[moduleId];
                if (!set) {
                    set = [[NSMutableSet alloc] init];
                    moduleIdToAspectDefines[moduleId] = set;
                }
                [set addObject:define];
            }
        }
        self.moduleIdToAspectDefinesDict = moduleIdToAspectDefines;
    }
    
    NSSet *annotationModuleDefines = [[CSAnnotation sharedInstance] fetchAnnotationModuleDefines];
    if ([annotationModuleDefines count] > 0) {
        NSMutableSet<CSSimpleModuleRegisterDefine*> *modDefineSet = [[NSMutableSet alloc] init];
        for (NSString *modClassName in annotationModuleDefines) {
            CSSimpleModuleRegisterDefine *define = [CSSimpleModuleRegisterDefine buildDefine:NSClassFromString(modClassName)];
            if (define) {
                [modDefineSet addObject:define];
            }
        }
        self.moduleDefineSet = modDefineSet;
    }
    
    NSSet *applicationPluginDefines = [[CSAnnotation sharedInstance] fetchAnnotationApplicationPluginDefines];
    if ([applicationPluginDefines count] > 0) {
        NSMutableSet<CSSimpleApplicationPluginDefine*> *pluginDefineSet = [[NSMutableSet alloc] init];
        for (NSString *pluginClassName in applicationPluginDefines) {
            CSSimpleApplicationPluginDefine *define = [CSSimpleApplicationPluginDefine buildDefine:NSClassFromString(pluginClassName)];
            if (define) {
                [pluginDefineSet addObject:define];
            }
        }
        self.applicationPluginDefineSet = pluginDefineSet;
    }
    
    NSSet<NSString*> *viewControllerClassNameSet = [[CSAnnotation sharedInstance] fetchAnnotationFirstViewControllerDefines];
    if ([viewControllerClassNameSet count]) {
        NSMutableSet<Class> *firstViewControllerSet = [[NSMutableSet alloc] init];
        for (NSString *vcClassName in viewControllerClassNameSet) {
            Class vcClass = NSClassFromString(vcClassName);
            if ([vcClass isSubclassOfClass:[UIViewController class]]) {
                [firstViewControllerSet addObject:vcClass];
            } else {
                WJLogError(@"❌ '%@' 'CSFirstViewController' annotation it has to be a 'UIViewController' subclass", vcClassName);
            }
        }
        self.firstViewControllerClassSet = firstViewControllerSet;
    } else {
        WJLogError(@"❌ application needs configured 'CSFirstViewController' annotations ");
    }
}

- (NSSet<id<CSApplicationPluginDefine>>*)getApplicationPluginDefineSet {
    return _applicationPluginDefineSet;
}

- (NSSet<Class>*)getFirstViewControllerClassSet {
    return _firstViewControllerClassSet;
}

- (id<CSModuleRegisterDefine>)generateModuleRegisterDefine:(Class<CSModule>)modClass {
    return [CSSimpleModuleRegisterDefine buildDefine:modClass];
}

- (NSSet<id<CSModuleRegisterDefine>> *)getModuleRegisterDefineSet {
    return _moduleDefineSet;
}

- (NSSet<id<CSServiceRegisterDefine>>*)getServiceRegisterDefineSet:(NSString*)moduleId {
    if (moduleId) {
        NSArray *a = [(NSDictionary*)[self moduleIdToServiceDefinesDict][moduleId] allValues];
        if ([a count] > 0) {
            return [NSSet setWithArray:a];
        }
    }
    return nil;
}

- (NSSet<id<CSAspectRegisterDefine>>*)getAspectRegisterDefineSet:(NSString*)moduleId {
    return self.moduleIdToAspectDefinesDict[moduleId];
}

@end
