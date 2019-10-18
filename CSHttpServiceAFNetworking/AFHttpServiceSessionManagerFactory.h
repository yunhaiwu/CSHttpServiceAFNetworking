//
//  AFHttpServiceSessionManagerFactory.h
//  CSHttpServiceAFNetworking
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaService/CocoaService.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@protocol AFHttpServiceSessionManagerFactory <CSService>

- (AFHTTPSessionManager*)getSessionManager;

@end
