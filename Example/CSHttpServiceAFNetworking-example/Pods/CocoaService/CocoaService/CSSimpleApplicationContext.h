//
//  CSSimpleApplicationContext.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMacroDefines.h"
#import "CSModule.h"
#import "CSService.h"
#import "CSApplicationContext.h"

/**
 *  应用程序上下文环境
 */
__attribute__((objc_subclassing_restricted))
@interface CSSimpleApplicationContext : NSObject<UIApplicationDelegate, CSApplicationContext>

@end
