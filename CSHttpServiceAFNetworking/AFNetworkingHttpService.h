//
//  AFNetworkingHttpService.h
//  CSHttpServiceAFNetworking-example
//
//  Created by wuyunhai on 2019/10/18.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaService/CocoaService.h>
#import <CSHttpServiceAPI/CSHttpServiceAPI.h>


@CSService(CSHttpService, AFNetworkingHttpService)
@interface AFNetworkingHttpService : NSObject<CSHttpService>

@end
