//
//  CSBlockTask.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSTask.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^CSTaskBlock)(void);
typedef void(^CSTaskCompletionBlock)(void);

@interface CSBlockTask : NSObject<CSTask>

@property (nonatomic, copy) CSTaskBlock taskBlock;

@property (nonatomic, copy) CSTaskCompletionBlock completionBlock;

@property (nonatomic, assign) BOOL async;

- (instancetype)initWithBlock:(CSTaskBlock)block async:(BOOL)async;

- (instancetype)initWithBlock:(CSTaskBlock)taskBlock completion:(CSTaskCompletionBlock)completionBlock async:(BOOL)async;

@end

NS_ASSUME_NONNULL_END
