//
//  CSSimpleAspectRegisterDefine.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSAspectRegisterDefine.h"


@interface CSSimpleAspectRegisterDefine : NSObject<CSAspectRegisterDefine>

+ (CSSimpleAspectRegisterDefine*)buildDefine:(Class<CSAspect>)aspectClass;

@end
