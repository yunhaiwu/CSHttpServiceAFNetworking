# CSHttpServiceAPI

cocoaservice http 请求组件api

### CocoaPods 安装

```
在Podfile 文件头部添加：
source：https://github.com/yunhaiwu/ios-wj-framework-cocoapods-specs.git

//HTTP服务API
pod CSHttpServiceAPI

```

### 要求
* ARC支持
* iOS 7.0+
* CocoaService (1.0+)

### 使用方法

```
    id<CSHttpService> httpService = [[[CocoaService sharedInstance] applicationContext] fetchService:@protocol(CSHttpService)];
    
    [httpService request:request responseClass:[SimpleResponseObject class] responseBlock:^(id<CSHttpResponse> response, NSError *error) {
        if (error) {
            //处理网络环境错误
        } else {
            if ([response isError]) {
                //接口数据逻辑错误
            } else {
                //请求成功
            }
        }
    }];

```
