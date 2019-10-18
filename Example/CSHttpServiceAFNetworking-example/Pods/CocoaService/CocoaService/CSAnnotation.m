//
//  CSAnnotation.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSAnnotation.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <mach-o/ldsyms.h>
#import "CSMonitorContext.h"

@interface CSAnnotation ()

@property (nonatomic, strong) NSMutableSet<NSString*> *moduleDefines, *serviceDefines, *appFirstViewControllerDefines;

@property (nonatomic, strong) NSMutableSet<NSString*> *aspectDefines;

+ (instancetype)sharedInstance;

@end

@implementation CSAnnotation

- (NSMutableSet<NSString *> *)moduleDefines {
    if (!_moduleDefines) {
        _moduleDefines = [[NSMutableSet alloc] init];
    }
    return _moduleDefines;
}

- (NSMutableSet<NSString *> *)serviceDefines {
    if (!_serviceDefines) {
        _serviceDefines = [[NSMutableSet alloc] init];
    }
    return _serviceDefines;
}

- (NSMutableSet<NSString *> *)aspectDefines {
    if (!_aspectDefines) {
        _aspectDefines = [[NSMutableSet alloc] init];
    }
    return _aspectDefines;
}

- (NSMutableSet<NSString *> *)appFirstViewControllerDefines {
    if (!_appFirstViewControllerDefines) {
        _appFirstViewControllerDefines = [[NSMutableSet alloc] init];
    }
    return _appFirstViewControllerDefines;
}

+ (instancetype)sharedInstance {
    static CSAnnotation *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSAnnotation alloc] init];
    });
    return instance;
}

- (NSSet<NSString*>*)fetchAnnotationModuleDefines {
    return _moduleDefines;
}

- (NSSet<NSString*>*)fetchAnnotationServiceDefines {
    return _serviceDefines;
}

- (NSSet<NSString*>*)fetchAnnotationAspectDefines {
    return _aspectDefines;
}

- (NSSet<NSString*>*)fetchAnnotationAppFirstViewControllerDefines {
    return _appFirstViewControllerDefines;
}

- (void)appendModDefines:(NSArray<NSString*>*)mods serviceDefines:(NSArray<NSString*>*)sers aspectDefines:(NSArray<NSString*>*)asps viewControllers:(NSArray<NSString*>*)viewControllers {
    if ([mods count]) {
        [self.moduleDefines addObjectsFromArray:mods];
    }
    if ([sers count]) {
        [self.serviceDefines addObjectsFromArray:sers];
    }
    if ([asps count]) {
        [self.aspectDefines addObjectsFromArray:asps];
    }
    if ([viewControllers count]) {
        [self.appFirstViewControllerDefines addObjectsFromArray:viewControllers];
    }
}

@end

NSArray<NSString *>* WJReadConfiguration(char *sectionName,const struct mach_header *mh) {
    NSMutableArray<NSString*> *annotionDefines = nil;
    unsigned long size = 0;
#ifndef __LP64__
    uintptr_t *memory = (uintptr_t*)getsectiondata(mh, SEG_DATA, sectionName, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mh;
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
#endif
    unsigned long counter = size/sizeof(void*);
    for(int idx = 0; idx < counter; ++idx){
        char *string = (char*)memory[idx];
        NSString *str = [NSString stringWithUTF8String:string];
        if(!str)continue;
        if (!annotionDefines) annotionDefines = [[NSMutableArray alloc] init];
        [annotionDefines addObject:str];
    }
    return annotionDefines;
}

static void dyld_add_image_callback(const struct mach_header *mh, intptr_t vmaddr_slide) {
    [[[CSMonitorContext sharedInstance] timeProfiler] beginAnnotationRead];
    Dl_info image_info;
    if (dladdr(mh, &image_info)) {
#if TARGET_OS_SIMULATOR
        const char *simulator_env_lib_name_prefix = "/Users";
        if (strncmp(simulator_env_lib_name_prefix, image_info.dli_fname, strlen(simulator_env_lib_name_prefix)) == 0) {
            NSArray<NSString*> *modules = WJReadConfiguration(CSModuleSectionName, mh);
            NSArray<NSString*> *services = WJReadConfiguration(CSServiceSectionName, mh);
            NSArray<NSString*> *aspects = WJReadConfiguration(CSAspectSectionName, mh);
            NSArray<NSString*> *viewControllers = WJReadConfiguration(CSAppFirstViewControllerSectionName, mh);
            [[CSAnnotation sharedInstance] appendModDefines:modules serviceDefines:services aspectDefines:aspects viewControllers:viewControllers];
        }
#else
        char main_lib_name_prefix[] = "/var";
        char private_lib_name_prefix[] = "/private";
        if (strncmp(private_lib_name_prefix, image_info.dli_fname, strlen(private_lib_name_prefix)) == 0 || strncmp(main_lib_name_prefix, image_info.dli_fname, strlen(main_lib_name_prefix)) == 0) {
            NSArray<NSString*> *modules = WJReadConfiguration(CSModuleSectionName, mh);
            NSArray<NSString*> *services = WJReadConfiguration(CSServiceSectionName, mh);
            NSArray<NSString*> *aspects = WJReadConfiguration(CSAspectSectionName, mh);
            NSArray<NSString*> *viewControllers = WJReadConfiguration(CSAppFirstViewControllerSectionName, mh);
            [[CSAnnotation sharedInstance] appendModDefines:modules serviceDefines:services aspectDefines:aspects viewControllers:viewControllers];
        }
#endif
    }
    [[[CSMonitorContext sharedInstance] timeProfiler] endAnnotationRead];
}

__attribute__((constructor))
void initAnnotationsFunc() {
    _dyld_register_func_for_add_image(dyld_add_image_callback);
}
