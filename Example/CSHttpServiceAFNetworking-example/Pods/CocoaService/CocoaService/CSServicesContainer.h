//
//  CSServicesContainer.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSServiceRegisterDefine.h"

@interface CSServicesContainer : NSObject

- (id)fetchService:(Protocol*)protocol serviceId:(NSString*)serviceId;

- (id)fetchService:(Protocol*)protocol;

- (NSArray*)fetchServices:(Protocol*)protocol;

- (Class)fetchServiceClass:(Protocol*)protocol;

- (NSArray<Class>*)fetchServiceClassList:(Protocol*)protocol;

- (void)batchRegisterServices:(NSSet<id<CSServiceRegisterDefine>>*)defines;

- (void)registerService:(id<CSServiceRegisterDefine>)define;

- (void)remvoeServicesByModuleId:(NSString*)moduleId;

@end
