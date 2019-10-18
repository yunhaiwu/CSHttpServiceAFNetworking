//
//  CSTaskTargetActionTask.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSTaskTargetActionTask : NSObject<CSTask>

@property (nonatomic, strong) id target;

@property (nonatomic, assign) SEL action;

@property (nonatomic, assign) BOOL async;

- (instancetype)initWithTarget:(id)target action:(SEL)action async:(BOOL)async;

@end

NS_ASSUME_NONNULL_END
