//
//  DTDE_CFPrivate.h
//  DeleteThatDamnEvent
//
//  Created by Nicolas BACHSCHMIDT on 13/12/11.
//  Copyright (c) 2011 Octiplex. All rights reserved.
//

#ifndef _DTDE_CF_PRIVATE_H_
#define _DTDE_CF_PRIVATE_H_

#include <CoreFoundation/CoreFoundation.h>

CF_EXPORT CFDictionaryRef _CFCopySystemVersionDictionary(void);
CF_EXPORT CFStringRef const _kCFSystemVersionProductVersionKey;
CF_EXPORT CFStringRef const _kCFSystemVersionBuildVersionKey;

#endif // _DTDE_CF_PRIVATE_H_

