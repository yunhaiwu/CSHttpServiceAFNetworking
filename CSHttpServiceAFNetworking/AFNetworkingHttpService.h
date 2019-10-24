//
//  AFNetworkingHttpService.h
//  CSHttpServiceAFNetworking
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaService/CocoaService.h>
#import <CSHttpServiceAPI/CSHttpServiceAPI.h>

@CSService(CSHttpService, AFNetworkingHttpService)
@interface AFNetworkingHttpService : NSObject<CSHttpService>

@end
