//
//  CSApplicationPluginManager.m
//  CocoaService-example
//
//  Created by wuyunhai on 2019/10/22.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import "CSApplicationPluginManager.h"
#import "CSApplicationPreloadDataManager.h"

@interface CSApplicationPluginManager ()

@property (nonatomic, strong) NSMutableSet<id<CSApplicationPlugin>> *plugins;

@end

@implementation CSApplicationPluginManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.plugins = [[NSMutableSet alloc] init];
        NSSet<id<CSApplicationPluginDefine>>*pluginDefineSet = [[CSApplicationPreloadDataManager sharedInstance] getApplicationPluginDefineSet];
        for (id<CSApplicationPluginDefine> define in pluginDefineSet) {
            id<CSApplicationPlugin> plugin = [[define pluginClass] sharedPlugin];
            if (plugin) [_plugins addObject:plugin];
        }
    }
    return self;
}

- (void)registerPlugins:(id<CSApplicationPlugin>)plugin {
    if (plugin) [_plugins addObject:plugin];
}


+ (id<CSApplicationPlugin>)sharedPlugin {
    return nil;
}

- (void)applicationStarting:(id<CSApplicationContext>)applicationContext {
    for (id<CSApplicationPlugin> plugin in _plugins) {
        if ([plugin respondsToSelector:@selector(applicationStarting:)]) {
            [plugin applicationStarting:applicationContext];
        }
    }
}

- (void)applicationContext:(id<CSApplicationContext>)applicationContext moduleWillLoad:(id<CSModuleContext>)moduleContext {
    for (id<CSApplicationPlugin> plugin in _plugins) {
        if ([plugin respondsToSelector:@selector(applicationContext:moduleWillLoad:)]) {
            [plugin applicationContext:applicationContext moduleWillLoad:moduleContext];
        }
    }
}

- (void)applicationContext:(id<CSApplicationContext>)applicationContext moduleDidDestroy:(id<CSModuleContext>)moduleContext {
    for (id<CSApplicationPlugin> plugin in _plugins) {
        if ([plugin respondsToSelector:@selector(applicationContext:moduleDidDestroy:)]) {
            [plugin applicationContext:applicationContext moduleDidDestroy:moduleContext];
        }
    }
}

@end
