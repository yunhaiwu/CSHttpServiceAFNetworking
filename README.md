# CSHttpServiceAFNetworking

cocoaservice http 请求组件api

### CocoaPods 安装

```
在Podfile 文件头部添加：
source：https://github.com/yunhaiwu/ios-wj-framework-cocoapods-specs.git

//HTTP服务API
pod CSHttpServiceAFNetworking
```

### 要求
* ARC支持
* iOS 7.0+
* CSHttpServiceAPI (1.0.0+)

### 使用方法

提供一个service供外部自由创建AFHTTPSessionManager，协议：AFHttpServiceSessionManagerFactory

```
@protocol AFHttpServiceSessionManagerFactory <CSService>

- (AFHTTPSessionManager*)getSessionManager;

@end

```
