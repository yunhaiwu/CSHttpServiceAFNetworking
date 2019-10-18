//
//  CocoaService.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMacroDefines.h"
#import "CSApplicationContext.h"
#import "NSObject+CSService.h"
#import "NSObject+CSModule.h"
#import "CSAspect.h"
#import "CSAnnotation.h"
#import "CSTaskScheduler.h"
#import "CSMonitorContext.h"
#import "CSSafeSet.h"
#import "CSSafeDictionary.h"
#import "CSSafeArray.h"
#import "CSSafeQueue.h"
#import "CSSafeStack.h"


__attribute__((objc_subclassing_restricted))
@interface CocoaService : NSObject<UIApplicationDelegate>

+ (instancetype)sharedInstance;

- (id<CSApplicationContext>)applicationContext;

@end
