//
//  AFNetworkingHttpService.m
//  CSHttpServiceAFNetworking-example
//
//  Created by wuyunhai on 2019/10/18.
//  Copyright © 2019 wuyunhai. All rights reserved.
//

#import "AFNetworkingHttpService.h"
#import "AFHttpServiceSessionManagerFactory.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "SimpleAFHttpServiceRequest.h"
#import "SimpleAFHttpServiceResponse.h"
#import <WJLoggingAPI/WJLoggingAPI.h>

@interface AFNetworkingHttpService ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) id<CSHttpServiceConfig> httpServiceConfig;

@property (nonatomic, copy) NSArray<id<CSHttpServiceInterceptor>> *httpServiceInterceptors;

@end

@implementation AFNetworkingHttpService

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

+ (BOOL)hasSingleton {
    return YES;
}

+ (id)sharedInstance {
    static AFNetworkingHttpService *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[AFNetworkingHttpService alloc] init];
    });
    return sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        id<AFHttpServiceSessionManagerFactory> factory = [[[CocoaService sharedInstance] applicationContext] fetchService:@protocol(AFHttpServiceSessionManagerFactory)];
        if (factory) {
            self.sessionManager = [factory getSessionManager];
            NSAssert(_sessionManager != nil, @"[CSHttpServiceAFNetworking] %@ getSessionManager return nil error.", NSStringFromClass([factory class]));
        } else {
            self.sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            AFSecurityPolicy *afSecurityPolicy = [AFSecurityPolicy defaultPolicy];
            [afSecurityPolicy setValidatesDomainName:NO];
            [self.sessionManager setSecurityPolicy:afSecurityPolicy];
            [self.sessionManager.securityPolicy setAllowInvalidCertificates:YES];
        }
        
        self.httpServiceConfig = [[[CocoaService sharedInstance] applicationContext] fetchService:@protocol(CSHttpServiceConfig)];
        if (_httpServiceConfig) {
            [[self.sessionManager operationQueue] setMaxConcurrentOperationCount:[_httpServiceConfig maxConcurrentNumber]];
        } else {
            [[self.sessionManager operationQueue] setMaxConcurrentOperationCount:CSHttpServiceDefaultMaxConcurrentNumber];
        }
        
        self.httpServiceInterceptors = [[[CocoaService sharedInstance] applicationContext] fetchServiceList:@protocol(CSHttpServiceInterceptor)];
    }
    return self;
}

- (BOOL)execInterceptorPreRequestHandle:(id<CSHttpRequest>)request error:(NSError**)error {
    BOOL canRequest = YES;
    for (id<CSHttpServiceInterceptor> interceptor in _httpServiceInterceptors) {
        canRequest = [interceptor preRequestHandle:request];
        if (!canRequest) {
            *error = [NSError errorWithDomain:@"AFNetworkingHttpService" code:1001 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ interceptor catch request ", NSStringFromClass([interceptor class])]}];
            break;
        }
    }
    return canRequest;
}

- (void)execInterceptorAfterResponseHandle:(id<CSHttpResponse>)response {
    for (id<CSHttpServiceInterceptor> interceptor in _httpServiceInterceptors) {
        [interceptor afterResponseHandle:response];
    }
}

#pragma mark CSHttpService
- (void)request:(id<CSHttpRequest> _Nonnull)request
  responseClass:(Class)responseClass
  responseBlock:(CSHttpServiceResponseBlock)responseBlock {
    if ([request respondsToSelector:@selector(validateParamsByError:)]) {
        NSError *error = nil;
        [request validateParamsByError:&error];
        if (error) {
            responseBlock(nil, error);
            return;
        }
    }
    if (![responseClass conformsToProtocol:@protocol(CSHttpResponse)]) {
        responseBlock(nil, [NSError errorWithDomain:@"AFNetworkingHttpService" code:1000 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ need implementation protocol 'CSHttpResponse' ", NSStringFromClass(responseClass)]}]);
        return;
    }
    NSError *interceptorError = nil;
    if (![self execInterceptorPreRequestHandle:request error:&interceptorError]) {
        responseBlock(nil, interceptorError);
        return;
    }
    
    int timeoutBySeconds = CSHttpServiceDefaultTimeoutBySeconds;
    AFHTTPRequestSerializer *reqSerializer = [AFHTTPRequestSerializer serializer];
    if ([request respondsToSelector:@selector(timeoutDurationBySeconds)]) {
        timeoutBySeconds = [request timeoutDurationBySeconds];
    } else if (_httpServiceConfig) {
        timeoutBySeconds = [_httpServiceConfig defaultTimeoutBySeconds];
    }
    reqSerializer.timeoutInterval = timeoutBySeconds > 0 ? : CSHttpServiceDefaultTimeoutBySeconds;
    self.sessionManager.requestSerializer = reqSerializer;
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if ([request respondsToSelector:@selector(headers)]) {
        NSDictionary<NSString*, NSString*> *headers = [request headers];
        NSArray<NSString*> *keys = [headers allKeys];
        for (NSString *key in keys) {
            [self.sessionManager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    CSHTTPMethod reqMethod = CSHTTPMethodGET;
    if ([request respondsToSelector:@selector(method)]) {
        reqMethod = [request method];
    }
    NSString *requestURL = [[request url] absoluteString];
    NSDictionary<NSString*, NSObject*> *requestParams = nil;
    if ([request respondsToSelector:@selector(params)]) {
        requestParams = [[request params] copy];
    }
    
    switch (reqMethod) {
        case CSHTTPMethodGET:
        {
            [self.sessionManager GET:requestURL parameters:requestParams progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id<CSHttpResponse> response = [responseClass buildResponseWithData:responseObject];
                [response setResponseData:responseObject];
                [self execInterceptorAfterResponseHandle:response];
                responseBlock(response, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                responseBlock(nil, error);
            }];
        }
            break;
        case CSHTTPMethodPOST:
        {
            NSArray<CSHttpFileUpload*> *uploadFiles = nil;
            if ([request respondsToSelector:@selector(uploadFiles)]) {
                uploadFiles = [request uploadFiles];
            }
            if ([uploadFiles count]) {
                [self.sessionManager POST:requestURL parameters:requestParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    for (CSHttpFileUpload *uploadFile in uploadFiles) {
                        if ([uploadFile fileExist]) {
                            [formData appendPartWithFileData:[NSData dataWithContentsOfFile:uploadFile.filePath] name:uploadFile.requestKey fileName:uploadFile.fileName mimeType:uploadFile.mimeType];
                        }
                    }
                } progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    id<CSHttpResponse> response = [responseClass buildResponseWithData:responseObject];
                    [response setResponseData:responseObject];
                    [self execInterceptorAfterResponseHandle:response];
                    responseBlock(response, nil);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    responseBlock(nil, error);
                }];
            } else {
                [self.sessionManager POST:requestURL parameters:requestParams progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    id<CSHttpResponse> response = [responseClass buildResponseWithData:responseObject];
                    [response setResponseData:responseObject];
                    [self execInterceptorAfterResponseHandle:response];
                    responseBlock(response, nil);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    responseBlock(nil, error);
                }];
            }
        }
            break;
        case CSHTTPMethodPUT:
        {
            [self.sessionManager PUT:requestURL parameters:requestParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id<CSHttpResponse> response = [responseClass buildResponseWithData:responseObject];
                [response setResponseData:responseObject];
                [self execInterceptorAfterResponseHandle:response];
                responseBlock(response, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                responseBlock(nil, error);
            }];
        }
            break;
        case CSHTTPMethodDELETE:
        {
            [self.sessionManager DELETE:requestURL parameters:requestParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id<CSHttpResponse> response = [responseClass buildResponseWithData:responseObject];
                [response setResponseData:responseObject];
                [self execInterceptorAfterResponseHandle:response];
                responseBlock(response, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                responseBlock(nil, error);
            }];
        }
            break;
        case CSHTTPMethodPATCH:
        {
            [self.sessionManager PATCH:requestURL parameters:requestParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id<CSHttpResponse> response = [responseClass buildResponseWithData:responseObject];
                [response setResponseData:responseObject];
                [self execInterceptorAfterResponseHandle:response];
                responseBlock(response, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                responseBlock(nil, error);
            }];
        }
        default:
            break;
    }
}


- (void)requestWithURL:(NSURL*)url
                method:(CSHTTPMethod)method
                params:(NSDictionary<NSString*, NSObject*>*)params
               headers:(NSDictionary<NSString*, NSString*>*)headers
         responseBlock:(CSHttpServiceResponseDataBlock) responseBlock {
    SimpleAFHttpServiceRequest *request = [[SimpleAFHttpServiceRequest alloc] init];
    [request setReqURL:url];
    [request setReqHttpMethod:method];
    [request setReqParams:params];
    [request setReqHeaders:headers];
    [self request:request responseClass:[SimpleAFHttpServiceResponse class] responseBlock:^(id<CSHttpResponse> response, NSError *error) {
        if (responseBlock) {
            if (error) {
                responseBlock(nil, error);
            } else {
                responseBlock([response responseData], nil);
            }
        }
    }];
}


- (void)downloadWithURL:(NSURL*)url
          responseBlock:(CSHttpServiceDownloadResponseBlock)downloadResponseBlock
               progress:(CSHttpServiceProgressBlock)progressBlock {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionTask *sessionTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) progressBlock([downloadProgress fractionCompleted]);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *filePath = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[response suggestedFilename]]];
        [[NSFileManager defaultManager] removeItemAtURL:filePath error:NULL];
        return filePath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (downloadResponseBlock) {
            if (error) {
                downloadResponseBlock(nil, error);
            } else {
                downloadResponseBlock(filePath.path, error);
            }
        }
    }];
    [sessionTask resume];
}

@end
