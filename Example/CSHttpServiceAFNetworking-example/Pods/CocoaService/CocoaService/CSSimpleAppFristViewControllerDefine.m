//
//  CSSimpleAppFristViewControllerDefine.m
//  CocoaService-example
//
//  Created by wuyunhai on 2019/10/14.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import "CSSimpleAppFristViewControllerDefine.h"
#import <UIKit/UIKit.h>
#import <WJLoggingAPI/WJLoggingAPI.h>

@interface CSSimpleAppFristViewControllerDefine ()

@property (nonatomic, assign) Class appFirstViewControllerClass;

@end

@implementation CSSimpleAppFristViewControllerDefine

- (instancetype)initWithClass:(Class)clazz {
    self = [super init];
    if (self) {
        _appFirstViewControllerClass = clazz;
    }
    return self;
}

+ (CSSimpleAppFristViewControllerDefine*)buildDefine:(Class)clazz {
    if ([clazz isSubclassOfClass:[UIViewController class]]) {
        return [[CSSimpleAppFristViewControllerDefine alloc] initWithClass:clazz];
    } else {
        WJLogError(@"❌ 'CSAppFirstViewController' annotation it has to be a 'UIViewController' subclass");
    }
    return nil;
}

#pragma mark CSAppFirstViewControllerDefine
- (Class)viewControllerClass {
    return _appFirstViewControllerClass;
}

@end
