//
//  CSApplicationPluginManager.h
//  CocoaService-example
//
//  Created by wuyunhai on 2019/10/22.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSApplicationPluginDefine.h"
#import "CSApplicationPlugin.h"

@interface CSApplicationPluginManager : NSObject<CSApplicationPlugin>

- (void)registerPlugins:(id<CSApplicationPlugin>)plugin;

@end
