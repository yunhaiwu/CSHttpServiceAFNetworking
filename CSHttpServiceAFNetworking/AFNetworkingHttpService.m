//
//  AFNetworkingHttpService.m
//  CSHttpServiceAFNetworking
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import "AFNetworkingHttpService.h"
#import "AFHttpServiceSessionManagerFactory.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "AFHttpServiceRequest.h"
#import "AFHttpServiceResponse.h"
#import "AFHttpServiceInterceptorWrapper.h"
#import "AFHttpContext.h"
#import <objc/runtime.h>

@interface AFHttpTaskModel : NSObject<CSHttpTask>

@property (nonatomic, weak) NSURLSessionTask *sessionTask;

- (instancetype)initWithSessionTask:(NSURLSessionTask*)sessionTask;

@end

@implementation AFHttpTaskModel

- (instancetype)initWithSessionTask:(NSURLSessionTask*)sessionTask {
    self = [super init];
    if (self) {
        _sessionTask = sessionTask;
    }
    return self;
}

#pragma mark CSHttpTask
- (BOOL)isLoading {
    if (_sessionTask) {
        NSURLSessionTaskState state = [_sessionTask state];
        if (state == NSURLSessionTaskStateRunning || state == NSURLSessionTaskStateSuspended) {
            return YES;
        }
    }
    return NO;
}

- (void)cancel {
    if (_sessionTask && [self isLoading]) {
        [_sessionTask cancel];
    }
}

- (NSURL* _Nullable)requestURL {
    if (_sessionTask) {
        return [[[_sessionTask currentRequest] URL] copy];
    }
    return nil;
}

@end


@interface NSURLSessionTask (AFHttpContext)

- (void)setAFHttpContext:(AFHttpContext *)context;

- (AFHttpContext *)getAFHttpContext;

@end

@implementation NSURLSessionTask (AFHttpContext)

- (void)setAFHttpContext:(AFHttpContext *)context {
    objc_setAssociatedObject(self, @selector(getAFHttpContext), context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AFHttpContext *)getAFHttpContext {
    return objc_getAssociatedObject(self, @selector(getAFHttpContext));
}

@end




@interface AFNetworkingHttpService ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) id<CSHttpServiceConfig> httpServiceConfig;

@property (nonatomic, copy) NSArray<AFHttpServiceInterceptorWrapper*> *httpServiceInterceptorWrappers;

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
        id<AFHttpServiceSessionManagerFactory> factory = [[[CocoaService sharedInstance] applicationContext] getService:@protocol(AFHttpServiceSessionManagerFactory)];
        if (factory) {
            self.sessionManager = [factory buildSessionManager];
            NSAssert(_sessionManager != nil, @"[CSHttpServiceAFNetworking] %@ getSessionManager return nil error.", NSStringFromClass([factory class]));
        } else {
            self.sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            AFSecurityPolicy *afSecurityPolicy = [AFSecurityPolicy defaultPolicy];
            [afSecurityPolicy setValidatesDomainName:NO];
            [self.sessionManager setSecurityPolicy:afSecurityPolicy];
            [self.sessionManager.securityPolicy setAllowInvalidCertificates:YES];
        }
        
        self.httpServiceConfig = [[[CocoaService sharedInstance] applicationContext] getService:@protocol(CSHttpServiceConfig)];
        if (_httpServiceConfig) {
            [[self.sessionManager operationQueue] setMaxConcurrentOperationCount:[_httpServiceConfig maxConcurrentNumber]];
        } else {
            [[self.sessionManager operationQueue] setMaxConcurrentOperationCount:CSHttpServiceDefaultMaxConcurrentNumber];
        }
        
        NSArray<id<CSHttpServiceInterceptor>> *httpServiceInterceptors = [[[CocoaService sharedInstance] applicationContext] getServiceList:@protocol(CSHttpServiceInterceptor)];
        if ([httpServiceInterceptors count]) {
            NSMutableArray *interceptorWrappers = [[NSMutableArray alloc] initWithCapacity:[httpServiceInterceptors count]];
            for (id<CSHttpServiceInterceptor> interceptor in httpServiceInterceptors) {
                [interceptorWrappers addObject:[[AFHttpServiceInterceptorWrapper alloc] initWithInterceptor:interceptor]];
            }
            self.httpServiceInterceptorWrappers = interceptorWrappers;
        }
    }
    return self;
}

- (BOOL)execInterceptorPreRequestHandle:(AFHttpContext*)context error:(NSError**)error {
    BOOL canRequest = YES;
    for (AFHttpServiceInterceptorWrapper *interceptorWrapper in _httpServiceInterceptorWrappers) {
        if ([interceptorWrapper hasPreRequestHandle]) {
            canRequest = [interceptorWrapper.interceptor preRequestHandle:context];
            if (!canRequest) {
                if (error != NULL) {
                    *error = [NSError errorWithDomain:@"AFNetworkingHttpService" code:1001 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ interceptor catch request ", NSStringFromClass([interceptorWrapper.interceptor class])]}];
                }
                break;
            }
        }
    }
    return canRequest;
}

- (void)execInterceptorAfterResponseHandle:(AFHttpContext*)context {
    for (AFHttpServiceInterceptorWrapper *interceptorWrapper in _httpServiceInterceptorWrappers) {
        if ([interceptorWrapper hasAfterResponseHandle]) {
            [interceptorWrapper.interceptor afterResponseHandle:context];
        }
    }
}

#pragma mark CSHttpService
- (id<CSHttpTask>)request:(id<CSHttpRequest> _Nonnull)request
  responseClass:(Class)responseClass
  responseBlock:(CSHttpServiceResponseBlock)responseBlock {
    id<CSHttpTask> httpTask = nil;
    if ([request respondsToSelector:@selector(validateParamsByError:)]) {
        NSError *error = nil;
        [request validateParamsByError:&error];
        if (error) {
            responseBlock(nil, error);
            return httpTask;
        }
    }
    if (![responseClass conformsToProtocol:@protocol(CSHttpResponse)]) {
        responseBlock(nil, [NSError errorWithDomain:@"AFNetworkingHttpService" code:1000 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ need implementation protocol 'CSHttpResponse' ", NSStringFromClass(responseClass)]}]);
        return httpTask;
    }
    AFHttpContext *context = [[AFHttpContext alloc] initWithRequest:request];
    NSError *interceptorError = nil;
    if (![self execInterceptorPreRequestHandle:context error:&interceptorError]) {
        responseBlock(nil, interceptorError);
        return httpTask;
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
    NSURLSessionDataTask *sessionDataTask = nil;
    switch (reqMethod) {
        case CSHTTPMethodGET:
        {
            sessionDataTask = [self.sessionManager GET:requestURL parameters:requestParams progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                AFHttpContext *httpContext = [task getAFHttpContext];
                id<CSHttpResponse> response = [CSHttpResponseBuilder buildResponseWithData:responseObject responseClass:responseClass];
                [httpContext setResponse:response];
                [self execInterceptorAfterResponseHandle:httpContext];
                httpContext.responseBlock(httpContext.response, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                AFHttpContext *httpContext = [task getAFHttpContext];
                httpContext.responseBlock(nil, error);
            }];
        }
            break;
        case CSHTTPMethodPOST:
        {
            NSArray<CSHttpFileUploadModel*> *uploadFiles = nil;
            if ([request respondsToSelector:@selector(uploadFiles)]) {
                uploadFiles = [request uploadFiles];
            }
            if ([uploadFiles count]) {
                sessionDataTask = [self.sessionManager POST:requestURL parameters:requestParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    for (CSHttpFileUploadModel *uploadFile in uploadFiles) {
                        if ([uploadFile fileExist]) {
                            [formData appendPartWithFileData:[NSData dataWithContentsOfFile:uploadFile.filePath] name:uploadFile.requestKey fileName:uploadFile.fileName mimeType:uploadFile.mimeType];
                        }
                    }
                } progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    AFHttpContext *httpContext = [task getAFHttpContext];
                    id<CSHttpResponse> response = [CSHttpResponseBuilder buildResponseWithData:responseObject responseClass:responseClass];
                    [httpContext setResponse:response];
                    [self execInterceptorAfterResponseHandle:httpContext];
                    httpContext.responseBlock(response, nil);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    AFHttpContext *httpContext = [task getAFHttpContext];
                    httpContext.responseBlock(nil, error);
                }];
            } else {
                sessionDataTask = [self.sessionManager POST:requestURL parameters:requestParams progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    AFHttpContext *httpContext = [task getAFHttpContext];
                    id<CSHttpResponse> response = [CSHttpResponseBuilder buildResponseWithData:responseObject responseClass:responseClass];
                    [httpContext setResponse:response];
                    [self execInterceptorAfterResponseHandle:httpContext];
                    httpContext.responseBlock(response, nil);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    AFHttpContext *httpContext = [task getAFHttpContext];
                    httpContext.responseBlock(nil, error);
                }];
            }
        }
            break;
        case CSHTTPMethodPUT:
        {
            sessionDataTask = [self.sessionManager PUT:requestURL parameters:requestParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                AFHttpContext *httpContext = [task getAFHttpContext];
                id<CSHttpResponse> response = [CSHttpResponseBuilder buildResponseWithData:responseObject responseClass:responseClass];
                [httpContext setResponse:response];
                [self execInterceptorAfterResponseHandle:httpContext];
                httpContext.responseBlock(response, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                AFHttpContext *httpContext = [task getAFHttpContext];
                httpContext.responseBlock(nil, error);
            }];
        }
            break;
        case CSHTTPMethodDELETE:
        {
            sessionDataTask = [self.sessionManager DELETE:requestURL parameters:requestParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                AFHttpContext *httpContext = [task getAFHttpContext];
                id<CSHttpResponse> response = [CSHttpResponseBuilder buildResponseWithData:responseObject responseClass:responseClass];
                [httpContext setResponse:response];
                [self execInterceptorAfterResponseHandle:httpContext];
                httpContext.responseBlock(response, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                AFHttpContext *httpContext = [task getAFHttpContext];
                httpContext.responseBlock(nil, error);
            }];
        }
            break;
        case CSHTTPMethodPATCH:
        {
            sessionDataTask = [self.sessionManager PATCH:requestURL parameters:requestParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                AFHttpContext *httpContext = [task getAFHttpContext];
                id<CSHttpResponse> response = [CSHttpResponseBuilder buildResponseWithData:responseObject responseClass:responseClass];
                [httpContext setResponse:response];
                [self execInterceptorAfterResponseHandle:httpContext];
                httpContext.responseBlock(response, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                AFHttpContext *httpContext = [task getAFHttpContext];
                httpContext.responseBlock(nil, error);
            }];
        }
        default:
            break;
    }
    if (sessionDataTask) {
        [context setResponseBlock:responseBlock];
        [sessionDataTask setAFHttpContext:context];
        httpTask = [[AFHttpTaskModel alloc] initWithSessionTask:sessionDataTask];
    }
    return httpTask;
}


- (id<CSHttpTask>)requestWithURL:(NSURL*)url
                method:(CSHTTPMethod)method
                params:(NSDictionary<NSString*, NSObject*>*)params
               headers:(NSDictionary<NSString*, NSString*>*)headers
         responseBlock:(CSHttpServiceResponseDataBlock) responseBlock {
    AFHttpServiceRequest *request = [[AFHttpServiceRequest alloc] init];
    [request setReqURL:url];
    [request setReqHttpMethod:method];
    [request setReqParams:params];
    [request setReqHeaders:headers];
    return [self request:request responseClass:[AFHttpServiceResponse class] responseBlock:^(id<CSHttpResponse> response, NSError *error) {
        if (responseBlock) {
            if (error) {
                responseBlock(nil, error);
            } else {
                responseBlock([response responseData], nil);
            }
        }
    }];
}


- (id<CSHttpTask>)downloadWithURL:(NSURL*)url
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
    return [[AFHttpTaskModel alloc] initWithSessionTask:sessionTask];
}

@end
