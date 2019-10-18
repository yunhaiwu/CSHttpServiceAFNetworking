//
//  AppDelegate.m
//  CSHttpServiceAFNetworking-example
//
//  Created by wuyunhai on 2019/10/18.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:[ViewController new]]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
