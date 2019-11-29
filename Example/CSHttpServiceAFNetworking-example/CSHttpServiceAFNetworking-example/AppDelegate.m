//
//  AppDelegate.m
//  CSHttpServiceAFNetworking-example
//
//  Created by wuyunhai on 2019/10/18.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <CocoaService/CocoaService.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    [[CocoaService sharedInstance] startLaunching:launchOptions];
    return [[CocoaService sharedInstance] application:application willFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[CocoaService sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:[ViewController new]]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
