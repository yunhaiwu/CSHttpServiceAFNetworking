//
//  CSHttpFileUploadModel.h
//  CocoaService-HttpServiceAPI
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

__attribute__((objc_subclassing_restricted))
@interface CSHttpFileUploadModel : NSObject

@property(nonatomic, copy) NSString *requestKey;

//mime type
@property(nonatomic, copy) NSString *mimeType;

//文件路径
@property(nonatomic, copy) NSString *filePath;

//文件名
@property(nonatomic, copy) NSString *fileName;

- (instancetype)initWithRequestKey:(NSString*)requestKey mimeType:(NSString*)mimeType fileName:(NSString*)fileName filePath:(NSString*)filePath;

/*
 文件是否存在
 */
- (BOOL)fileExist;

@end
