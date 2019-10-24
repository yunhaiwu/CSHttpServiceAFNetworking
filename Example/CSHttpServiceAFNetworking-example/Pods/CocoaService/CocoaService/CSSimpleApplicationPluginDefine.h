//
//  CSSimpleApplicationPluginDefine.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSApplicationPluginDefine.h"

@interface CSSimpleApplicationPluginDefine : NSObject<CSApplicationPluginDefine>

+ (CSSimpleApplicationPluginDefine*)buildDefine:(Class)clazz;

@end
