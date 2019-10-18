//
//  CSApplicationContext.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSServiceRegisterDefine.h"
#import "CSAspectRegisterDefine.h"

@protocol CSApplicationContext <NSObject>

- (void)batchRegisterServices:(NSSet<id<CSServiceRegisterDefine>>*)serviceDefines;

- (void)registerService:(id<CSServiceRegisterDefine>)serviceDefine;

- (void)registerService:(Protocol*)protocol serviceClass:(Class)serviceClass;

- (id)fetchService:(Protocol*)protocol serviceId:(NSString*)serviceId;

- (id)fetchService:(Protocol*)protocol;

- (NSArray*)fetchServiceList:(Protocol*)protocol;

- (Class)fetchServiceClass:(Protocol*)protocol;

- (NSArray<Class>*)fetchServiceClassList:(Protocol*)protocol;

- (void)registerModule:(Class)modClass;

- (void)unRegisterModule:(Class)modClass;

- (id)fetchServiceProxy:(id)targetService;

- (void)registerAspect:(Class)aspectClass;

- (void)batchRegisterAspects:(NSSet<id<CSAspectRegisterDefine>>*)aspects;

@end
