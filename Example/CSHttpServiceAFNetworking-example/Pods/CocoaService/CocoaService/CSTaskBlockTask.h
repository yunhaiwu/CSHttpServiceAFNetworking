//
//  CSTaskBlockTask.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSTask.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^CSTaskBlock)(void);

@interface CSTaskBlockTask : NSObject<CSTask>

@property (nonatomic, copy) CSTaskBlock taskBlock;

@property (nonatomic, assign) BOOL async;

- (instancetype)initWithBlock:(CSTaskBlock)block async:(BOOL)async;

@end

NS_ASSUME_NONNULL_END
