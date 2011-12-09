//
//  NSProcessInfo+DTDEPlugin.m
//  DeleteThatDamnEvent
//
//  Created by Nicolas BACHSCHMIDT on 09/12/11.
//  Copyright (c) 2011 Octiplex. All rights reserved.
//

#import "NSProcessInfo+DTDEPlugin.h"
#import <sys/sysctl.h>

@implementation NSProcessInfo (DTDEPlugin)

- (NSString *)operatingSystemShortVersion
{
    SInt32 versionMajor = 0;
    SInt32 versionMinor = 0;
    SInt32 versionBugFix = 0;
    Gestalt(gestaltSystemVersionMajor, &versionMajor);
    Gestalt(gestaltSystemVersionMinor, &versionMinor);
    Gestalt(gestaltSystemVersionBugFix, &versionBugFix);
    
    if ( versionBugFix )
        return [NSString stringWithFormat:@"%d.%d.%d", versionMajor, versionMinor, versionBugFix];
    
    return [NSString stringWithFormat:@"%d.%d", versionMajor, versionMinor];
}

- (NSString *)operatingSystemBuildNumber
{
    int mib[2];
    size_t len = 0;
    char *rstring = NULL;
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_OSVERSION;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    rstring = malloc(len);
    sysctl(mib, 2, rstring, &len, NULL, 0);
    NSString *buildNumber = [NSString stringWithUTF8String:rstring];
    free(rstring);
    return buildNumber;
}

@end
