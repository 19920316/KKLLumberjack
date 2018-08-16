//
//  KKLLog.m
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/4/23.
//

#import "KKLLog.h"
#import <CocoaLumberjack/CocoaLumberjack.h>



#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;//DDLogLevelError;
#endif


@implementation KKLLog

static dispatch_queue_t _kklLoggingQueue;

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (void)initialize {
    _kklLoggingQueue = dispatch_queue_create("kkl.lumberjack", DISPATCH_QUEUE_SERIAL);
    
}

/**
 * Provides access to the logging queue.
 **/
+ (dispatch_queue_t)kklLoggingQueue {
    return _kklLoggingQueue;
}

//+ (dispatch_queue_t)kklLoggerQueue {
//    return _kklLoggerQueue;
//}

#pragma mark --- 日志打印方法

void KKLLogError (NSString *format,...) {
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        kklLog(KKLLogLevelError, message);
    }
}
void KKLLogWarn (NSString *format,...) {
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        kklLog(KKLLogLevelWarning, message);
    }
}
extern void KKLLogInfo (NSString *format,...) {
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        kklLog(KKLLogLevelInfo, message);
    }
}
extern void KKLLogDebug (NSString *format,...) {
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        kklLog(KKLLogLevelDebug, message);
    }
}
extern void KKLLogVerbose (NSString *format,...) {
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        kklLog(KKLLogLevelVerbose, message);
    }
}

void kklLog (KKLLogLevel level,NSString *format, ... ) {
//    if (level > [[KKLLog class] level]) {
//        return;
//    }
    switch (level) {
        case KKLLogLevelError:
            {
                DDLogError(@"%@", format);
            }
            break;
        case KKLLogLevelWarning:
            {
                DDLogWarn(@"%@", format);
            }
            break;
        case KKLLogLevelInfo:
            {
                DDLogInfo(@"%@", format);
            }
            break;
        case KKLLogLevelDebug:
            {
                DDLogDebug(@"%@", format);
            }
            break;
        case KKLLogLevelVerbose:
            {
                DDLogVerbose(@"%@", format);
            }
            break;
            
        default:
            break;
    }
}

#pragma mark --- 由策略添加对应日志记录器
- (void)addStrategy:(id <KKLLoggerPro>)strategy {
    id logger = [strategy logger];
    [DDLog addLogger:logger];
}



@end

























