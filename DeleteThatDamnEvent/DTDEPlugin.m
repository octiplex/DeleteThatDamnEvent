//
//  DTDEPlugin.m
//  DeleteThatDamnEvent
//
//  Created by Nicolas BACHSCHMIDT on 09/12/11.
//  Copyright (c) 2011 Octiplex. All rights reserved.
//

#import "DTDEPlugin.h"
#import "DTDE_CFPrivate.h"

#import <objc/runtime.h>

@implementation DTDEPlugin

+ (NSString *)defaultUserAgent
{
    static NSString *userAgent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSBundle *bundle = nil;
        
        NSString *systemName = @"Mac OS X";
        CFDictionaryRef systemInfo = _CFCopySystemVersionDictionary();
        
        if ( systemInfo )
        {
            systemName = [NSString stringWithFormat:@"Mac OS X/%@ (%@)",
                          CFDictionaryGetValue(systemInfo, _kCFSystemVersionProductVersionKey),
                          CFDictionaryGetValue(systemInfo, _kCFSystemVersionBuildVersionKey)];
            CFRelease(systemInfo);
        }
        
        bundle = [NSBundle bundleForClass:[DTDEPlugin class]];
        NSString *pluginName = [NSString stringWithFormat:@"DTDEPlugin/%@ (%@)",
                                [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                [bundle objectForInfoDictionaryKey:@"CFBundleVersion"]];
        
        bundle = [NSBundle bundleForClass:NSClassFromString(@"CalCalendarStore")];
        NSString *calendarStoreName = [NSString stringWithFormat:@"CalendarStore/%@ (%@)",
                                       [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                       [bundle objectForInfoDictionaryKey:@"CFBundleVersion"]];
        
        userAgent = [[NSString alloc] initWithFormat:@"%@; %@; %@;", calendarStoreName, pluginName, systemName];
    });
    
    return userAgent;
}


+ (void)load
{
    NSString *applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    BOOL isPre5 = [applicationVersion compare:@"5.0" options:NSNumericSearch] == NSOrderedAscending;
    
    NSString *dstClassName = isPre5
    ? @"DAVSession"  // iCal 4
    : @"CalSession"; // iCal 5
    
    Class dstClass = NSClassFromString(dstClassName);

    if ( ! dstClass ) {
        NSLog(@"%@: ERROR: could not find class named \"%@\"", self, dstClassName);
        return;
    }
    
    SEL selector = @selector(defaultUserAgent);
    Method dstMethod = class_getClassMethod(dstClass, selector);
    if ( ! dstMethod ) {
        NSLog(@"%@: ERROR: no method +[%@ %s]", self, dstClass, (const char *)selector);
        return;
    }
    
    Method srcMethod = class_getClassMethod(self, selector);
    IMP implementation = method_getImplementation(srcMethod);
    method_setImplementation(dstMethod, implementation);
    
    NSString *userAgent = [dstClass performSelector:@selector(defaultUserAgent)];
    NSLog(@"%@: Default User Agent is now \"%@\"", self, userAgent);
    
    if ( isPre5 )
    {
        // User-Agent already set in the instanciated DAVSession
        @try {
            // KVC is my friend!
            Class managerClass = NSClassFromString(@"CalDAVPrincipalManager");
            [managerClass setValue:userAgent forKeyPath:@"defaultManager.principalsArray.session.userAgent"];
        }
        @catch (NSException *exception) {
            // NSUndefinedKeyException, welcome!
            NSLog(@"%@: ERROR: %@", self, exception);
        }
    }
}

@end

