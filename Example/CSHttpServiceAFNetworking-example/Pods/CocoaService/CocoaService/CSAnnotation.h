//
//  CSAnnotation.h
//  CocoaService-Framework
//
//  Created by 吴云海
//  Copyright © 2018年 yunhai.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSMacroDefines.h"

#ifndef CSModuleSectionName
    #define CSModuleSectionName "cs_module"
#endif

#ifndef CSServiceSectionName
    #define CSServiceSectionName "cs_service"
#endif

#ifndef CSAspectSectionName
    #define CSAspectSectionName "cs_aspect"
#endif

#ifndef CSApplicationPluginSectionName
    #define CSApplicationPluginSectionName "cs_app_plugin"
#endif

#ifndef CSFirstViewControllerSectionName
    #define CSFirstViewControllerSectionName "cs_first_vc"
#endif

#define CSMacroInjectionMachOSectionData(sectionName) __attribute((used, section("__DATA,"#sectionName" ")))


#define CSFirstViewController(name) \
class CSAnnotation; char * k##name##vc CSMacroInjectionMachOSectionData(cs_first_vc) = ""#name"";

#define CSModule(name) \
class CSAnnotation; char * k##name##m CSMacroInjectionMachOSectionData(cs_module) = ""#name"";

#define CSReigisterServiceMethod2(S,I) \
class CSAnnotation; char * k##S##_##I##ms CSMacroInjectionMachOSectionData(cs_service) = ""#S":"#I"";

#define CSReigisterServiceMethod1(I) \
class CSAnnotation; char * kCSService_##I##ms CSMacroInjectionMachOSectionData(cs_service) = "CSService:"#I"";

#define CSService(...)          CSMacroPerform2ArgumentsMethod(__VA_ARGS__, CSReigisterServiceMethod2, CSReigisterServiceMethod1, ...)(__VA_ARGS__)

#define CSAspect(name) \
class CSAnnotation; char * k##name##ma CSMacroInjectionMachOSectionData(cs_aspect) = ""#name"";

#define CSApplicationPlugin(name) \
class CSAnnotation; char * k##name##ma CSMacroInjectionMachOSectionData(cs_app_plugin) = ""#name"";

/**
 Annotation
 */
@interface CSAnnotation : NSObject

+ (instancetype)sharedInstance;

- (NSSet<NSString*>*)fetchAnnotationApplicationPluginDefines;

- (NSSet<NSString*>*)fetchAnnotationFirstViewControllerDefines;

- (NSSet<NSString*>*)fetchAnnotationModuleDefines;

- (NSSet<NSString*>*)fetchAnnotationServiceDefines;

- (NSSet<NSString*>*)fetchAnnotationAspectDefines;

@end
