//
//  CSHttpTask.h
//  CocoaService-HttpServiceAPI
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSHttpTask <NSObject>

- (BOOL)isLoading;

- (void)cancel;

- (NSURL* _Nullable)requestURL;

@end
