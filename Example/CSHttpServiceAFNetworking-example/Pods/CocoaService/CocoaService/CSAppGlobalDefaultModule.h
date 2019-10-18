//
//  CSAppGlobalDefaultModule.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSModule.h"

/**
 全局基础模块
 不可卸载
 */
__attribute__((objc_subclassing_restricted))
@interface CSAppGlobalDefaultModule : NSObject<CSModule>

@property (nonatomic, weak) id<CSModuleContext> modContext;

@end
