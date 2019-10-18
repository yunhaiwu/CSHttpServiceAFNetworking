//
//  CocoaService.m
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CocoaService.h"
#import "CSSimpleApplicationContext.h"

@interface CocoaService ()

@property (nonatomic, strong) id<CSApplicationContext, UIApplicationDelegate> applicationContext;

@end

@implementation CocoaService

+ (instancetype)sharedInstance {
    static CocoaService *sharedObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[CocoaService alloc] init];
    });
    return sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.applicationContext = [[CSSimpleApplicationContext alloc] init];
    }
    return self;
}

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

- (id<CSApplicationContext>)applicationContext {
    return _applicationContext;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _applicationContext;
}

@end
