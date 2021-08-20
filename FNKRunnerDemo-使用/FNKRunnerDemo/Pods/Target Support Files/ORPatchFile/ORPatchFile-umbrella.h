#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BinaryPatchHelper.h"
#import "ClassSecretKeyMap.h"
#import "JSONPatchHelper.h"
#import "ORPatchFile.h"
#import "RunnerClasses.h"

FOUNDATION_EXPORT double ORPatchFileVersionNumber;
FOUNDATION_EXPORT const unsigned char ORPatchFileVersionString[];

