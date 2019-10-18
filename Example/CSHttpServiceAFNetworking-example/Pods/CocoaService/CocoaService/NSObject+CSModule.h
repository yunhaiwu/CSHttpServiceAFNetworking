//
//  NSObject+CSModule.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CSModule)<CSModule>

@property (nonatomic, weak) id<CSModuleContext> modContext;

@end

NS_ASSUME_NONNULL_END
