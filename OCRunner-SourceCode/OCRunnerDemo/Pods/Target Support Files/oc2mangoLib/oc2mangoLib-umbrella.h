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

#import "Log.h"
#import "oc2mangoLib.h"
#import "Parser.h"
#import "AST.h"
#import "Convert.h"
#import "MakeDeclare.h"

FOUNDATION_EXPORT double oc2mangoLibVersionNumber;
FOUNDATION_EXPORT const unsigned char oc2mangoLibVersionString[];

