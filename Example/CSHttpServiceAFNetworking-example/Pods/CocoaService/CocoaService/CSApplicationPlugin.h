//
//  CSApplicationPlugin.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSApplicationContext.h"
#import "CSModuleContext.h"

@protocol CSApplicationPlugin <NSObject>

+ (id<CSApplicationPlugin>)sharedPlugin;

@optional

- (void)applicationStarting:(id<CSApplicationContext>)applicationContext;

- (void)applicationContext:(id<CSApplicationContext>)applicationContext moduleWillLoad:(id<CSModuleContext>)moduleContext;

- (void)applicationContext:(id<CSApplicationContext>)applicationContext moduleDidDestroy:(id<CSModuleContext>)moduleContext;

@end
