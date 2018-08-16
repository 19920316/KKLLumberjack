//
//  KKLLogFormatter.m
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/4/19.
//

#import "KKLLogFormatter.h"
#import <libkern/OSAtomic.h>
#import <CocoaLumberjack/DDLog.h>
#import "PerformanceManager.h"


@interface KKLLogFormatter () <DDLogFormatter> {
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}
@end

@implementation KKLLogFormatter

- (NSString *)stringFromDate:(NSDate *)date {
    int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);
    if (loggerCount <= 1) {
        // Single-threaded mode. 单记录器模式
        if (threadUnsafeDateFormatter == nil) {
            threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [threadUnsafeDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
        }
        return [threadUnsafeDateFormatter stringFromDate:date];
    } else {
        // Multi-threaded mode. 多记录器模式
        // NSDateFormatter is NOT thread-safe.
        NSString *key = @"KKLLogFormatter_NSDateFormatter";
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        return [dateFormatter stringFromDate:date];
    }
}
#pragma mark 自定义日志格式

/**
 可以拼接上任何想携带的日志参数

 @param logMessage logMessage description
 @return 自定义的日志json字符串
 */
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    if (logMessage == nil) {
        return @"日志内容为空";
    }
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"E"; break;
        case DDLogFlagWarning  : logLevel = @"W"; break;
        case DDLogFlagInfo     : logLevel = @"I"; break;
        case DDLogFlagDebug    : logLevel = @"D"; break;
        default                : logLevel = @"V"; break;
    }
    
    NSString *dateAndTime = [self stringFromDate:(logMessage.timestamp)];
    NSString *logMsg = logMessage->_message;
        
    // 获取日志携带的参数
    float diskSpace = [[PerformanceManager sharedInstance]diskSpaceFree];
    
    NSInteger fps = [PerformanceManager sharedInstance].fps;
    
    NSString *log = [NSString stringWithFormat:@"%@ %@ | %@拼接日志参数:磁盘剩余空间：%.0f---FPS：%ld", logLevel, dateAndTime, logMsg,diskSpace,fps];
    
    return log;
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    OSAtomicIncrement32(&atomicLoggerCount);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    OSAtomicDecrement32(&atomicLoggerCount);
}


@end





































