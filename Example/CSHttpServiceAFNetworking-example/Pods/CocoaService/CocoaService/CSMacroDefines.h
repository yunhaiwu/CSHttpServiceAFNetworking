//
//  CSMacroDefines.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#ifndef CSMacroDefines_h
#define CSMacroDefines_h

//应用程序全局模块id
extern NSString *const CSAppGlobalDefaultModuleId;

//应用程序模块即将卸载通知
extern NSString *const CSApplicationContextModuleWillDestroyNotification;

//应用程序模块完成卸载通知
extern NSString *const CSApplicationContextModuleDidDestroyNotification;

//应用程序模块即将加载通知
extern NSString *const CSApplicationContextModuleWillLoadNotification;

//应用程序模块完成加载通知
extern NSString *const CSApplicationContextModuleDidLoadNotification;



#define CSMacroPerform1ArgumentsMethod(_0, NAME, ...)                                      NAME
#define CSMacroPerform2ArgumentsMethod(_0, _1, NAME, ...)                                  NAME
#define CSMacroPerform3ArgumentsMethod(_0, _1, _2, NAME, ...)                              NAME
#define CSMacroPerform4ArgumentsMethod(_0, _1, _2, _3, NAME, ...)                          NAME
#define CSMacroPerform5ArgumentsMethod(_0, _1, _2, _3, _4, NAME, ...)                      NAME
#define CSMacroPerform6ArgumentsMethod(_0, _1, _2, _3, _4, _5, NAME, ...)                  NAME
#define CSMacroPerform7ArgumentsMethod(_0, _1, _2, _3, _4, _5, _6, NAME, ...)              NAME
#define CSMacroPerform8ArgumentsMethod(_0, _1, _2, _3, _4, _5, _6, _7, NAME, ...)          NAME
#define CSMacroPerform9ArgumentsMethod(_0, _1, _2, _3, _4, _5, _6, _7, _8, NAME, ...)      NAME

#define CSAppContext                                        [[CocoaService sharedInstance] applicationContext]

#define CSFetchServiceMethod1(P)                            [CSAppContext fetchService:P]
#define CSFetchServiceMethod2(P,S)                          [CSAppContext fetchService:P serviceId:S]

#define CSFetchService(...)                                 CSMacroPerform2ArgumentsMethod(__VA_ARGS__, CSFetchServiceMethod2, CSFetchServiceMethod1, ...)(__VA_ARGS__)

#define CSFetchServiceList(P)                               [CSAppContext fetchServiceList:P]

#define CSFetchServiceClass(P)                              [CSAppContext fetchServiceClass:P]

#define CSFetchServiceClassList(P)                          [CSAppContext fetchServiceClassList:P]

#endif /* CSMacroDefines_h */
