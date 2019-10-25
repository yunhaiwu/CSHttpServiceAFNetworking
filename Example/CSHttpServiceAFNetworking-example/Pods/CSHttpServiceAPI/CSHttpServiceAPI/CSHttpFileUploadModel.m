//
//  CSHttpFileUploadModel.m
//  CocoaService-HttpServiceAPI
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "CSHttpFileUploadModel.h"

@implementation CSHttpFileUploadModel

- (instancetype)initWithRequestKey:(NSString*)requestKey mimeType:(NSString*)mimeType fileName:(NSString*)fileName filePath:(NSString*)filePath {
    self = [super init];
    if (self) {
        self.requestKey = requestKey;
        self.mimeType = mimeType;
        self.fileName = fileName;
        self.filePath = filePath;
    }
    return self;
}

- (BOOL)fileExist {
    return [[NSFileManager defaultManager] fileExistsAtPath:_filePath];
}

@end
