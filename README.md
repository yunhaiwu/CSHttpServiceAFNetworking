# CSHttpServiceAFNetworking

基于AFNetworking对CSHttpServiceAPI实现库，业务层使用CSHttpServiceAPI，无需关心是如何实现，解决一些外部库大版本升级或者替换带来的大规模修改和不兼容问题。

### CocoaPods 安装

```
在Podfile 文件头部添加：
source：https://github.com/yunhaiwu/ios-wj-framework-cocoapods-specs.git

pod 'CSHttpServiceAFNetworking'
```

### 要求
* ARC支持
* iOS 7.0+
* CSHttpServiceAPI (1.0.0+)

### 使用方法

具体使用请参考 [CSHttpServiceAPI](https://github.com/yunhaiwu/CSHttpServiceAPI.git).

提供一个service供外部自由创建AFHTTPSessionManager，协议：AFHttpServiceSessionManagerFactory，主要针对有扩展需求的项目

```
@protocol AFHttpServiceSessionManagerFactory <CSService>

- (AFHTTPSessionManager*)getSessionManager;

@end

```
