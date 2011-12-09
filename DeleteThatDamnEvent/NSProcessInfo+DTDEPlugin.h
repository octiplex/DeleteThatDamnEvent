//
//  NSProcessInfo+DTDEPlugin.h
//  DeleteThatDamnEvent
//
//  Created by Nicolas BACHSCHMIDT on 09/12/11.
//  Copyright (c) 2011 Octiplex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSProcessInfo (DTDEPlugin)

- (NSString *)operatingSystemShortVersion;
- (NSString *)operatingSystemBuildNumber;

@end
