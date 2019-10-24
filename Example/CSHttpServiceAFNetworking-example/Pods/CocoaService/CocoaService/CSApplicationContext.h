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
#import "CSSafeDictionary.h"

/*
 应用程序上下文环境
 */
@protocol CSApplicationContext <NSObject>

- (void)batchRegisterServices:(NSSet<__kindof id<CSServiceRegisterDefine>>* _Nonnull )serviceDefines;

- (void)registerService:(id<CSServiceRegisterDefine> _Nonnull)serviceDefine;

- (void)registerService:(Protocol* _Nonnull )protocol serviceClass:(Class _Nonnull)serviceClass;

- (id _Nullable)fetchService:(Protocol* _Nonnull )protocol serviceId:(NSString* _Nullable )serviceId;

- (id _Nullable)fetchService:(Protocol* _Nonnull )protocol;

- (NSArray* _Nullable)fetchServiceList:(Protocol* _Nonnull )protocol;

- (Class _Nullable)fetchServiceClass:(Protocol* _Nonnull )protocol;

- (NSArray<Class>* _Nullable)fetchServiceClassList:(Protocol* _Nonnull )protocol;

- (void)registerModule:(Class _Nonnull)modClass;

- (void)unRegisterModule:(Class _Nonnull)modClass;

- (id _Nullable)fetchServiceProxy:(id _Nullable)targetService;

- (void)registerAspect:(Class _Nonnull)aspectClass;

- (void)batchRegisterAspects:(NSSet<__kindof id<CSAspectRegisterDefine>>* _Nonnull)aspects;

@end
