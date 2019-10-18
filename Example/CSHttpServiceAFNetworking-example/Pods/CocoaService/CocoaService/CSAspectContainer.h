//
//  CSAspectContainer.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSAspect.h"
#import "CSAspectContext.h"
#import "CSAspectRegisterDefine.h"
#import "CSAspectServiceProxy.h"


NS_ASSUME_NONNULL_BEGIN

@interface CSAspectContainer : NSObject

- (void)registerAspect:(id<CSAspectRegisterDefine>)aspectRegisterDefine;

- (void)batchRegisterAspects:(NSSet<id<CSAspectRegisterDefine>>*)aspectRegisterDefineSet;

- (id)fetchServiceProxy:(id)service;

- (void)removeAspectsByModuleId:(NSString*)moduleId;

@end

NS_ASSUME_NONNULL_END
