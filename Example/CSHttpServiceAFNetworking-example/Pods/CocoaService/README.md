# CocoaService

服务化中间件

```
在Podfile 文件头部添加：
source：https://github.com/yunhaiwu/ios-wj-framework-cocoapods-specs.git
    
pod 'CocoaService'    
```

## 要求
* ARC支持
* iOS 5.0+
* WJLoggingAPI(1.0+)

## 使用方法

### 1、配置、启动

**@CSFirstViewController** 应用程序第一个出现的视图控制器，只要用来感知应用程序启动完成(首页完全出现)，此注解可以配置多个，如果window.rootViewController = UITabBarController，UITabBarController viewControllers都需要配置，@CSFirstViewController，注意如果 viewControllers 是UINavigationController，则配置在 firstViewController 视图控制器上，因为这个viewcontroller是最先显示的

```
//AppDelegate 所有回调方法中不要写业务逻辑，如果有此需求在下面模块中介绍如何配置
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    return [[CocoaService sharedInstance] application:application willFinishLaunchingWithOptions:launchOptions];
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return [[CocoaService sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

......

@end

```
### 2、模块
**@CSModule** 标记一个模块入口对象
```

```

### 3、服务
**@CSService** 标记一个服务
```

```

### 4、切面
**@CSAspect** 标记一个切面
```

```

### 5、插件
**@CSApplicationPlugin** 标记一个插件
```

```

### 5、监控
```

```
