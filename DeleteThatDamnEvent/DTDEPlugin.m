//
//  DTDEPlugin.m
//  DeleteThatDamnEvent
//
//  Created by Nicolas BACHSCHMIDT on 09/12/11.
//  Copyright (c) 2011 Octiplex. All rights reserved.
//

#import "DTDEPlugin.h"
#import "NSProcessInfo+DTDEPlugin.h"

#import <objc/runtime.h>

@implementation DTDEPlugin

+ (NSString *)defaultUserAgent
{
    NSBundle *bundle = [NSBundle bundleForClass:[DTDEPlugin class]];
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    return [NSString stringWithFormat:@"%@/%@ (%@); Mac OS X/%@ (%@)",
            [bundle objectForInfoDictionaryKey:@"CFBundleName"],
            [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
            [bundle objectForInfoDictionaryKey:@"CFBundleVersion"],
            processInfo.operatingSystemShortVersion, processInfo.operatingSystemBuildNumber];
}

+ (void)load
{
    const char *className = "CalSession";
    Class dstClass = objc_getClass(className);
    
    if ( ! dstClass ) {
        NSLog(@"%@: ERROR: No class \"%s\"", self, className);
        return;
    }
    
    SEL selector = @selector(defaultUserAgent);
    if ( ! class_getClassMethod(dstClass, selector) ) {
        NSLog(@"%@: ERROR: No method +[%s %s]", self, className, (const char *)selector);
        return;
    }
    
    Method method = class_getClassMethod(self, selector);
    char *returnType = method_copyReturnType(method);
    IMP implementation = method_getImplementation(method);
    Class dstMeta = objc_getMetaClass(className);
    
    class_replaceMethod(dstMeta, selector, implementation, returnType);
    free(returnType);
    
    NSString *userAgent = [dstClass performSelector:@selector(defaultUserAgent)];
    NSLog(@"%@: Default User Agent is now \"%@\"", self, userAgent);
}

@end

