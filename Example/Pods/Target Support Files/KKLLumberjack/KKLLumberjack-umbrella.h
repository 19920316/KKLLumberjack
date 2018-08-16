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

#import "CatchCrash.h"
#import "DeviceManager.h"
#import "KKLFileLoggerStrategy.h"
#import "KKLLog.h"
#import "KKLLogFormatter.h"
#import "KKLLogger.h"
#import "KKLLoggerStrategy.h"
#import "KKLLumberjack.h"
#import "KKLTTYLoggerStrategy.h"
#import "PerformanceManager.h"

FOUNDATION_EXPORT double KKLLumberjackVersionNumber;
FOUNDATION_EXPORT const unsigned char KKLLumberjackVersionString[];

