//
//  KKLLogFormatter.h
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/4/19.
//

/*
 自定义的的 log 消息体
 自定义一个 LogFormatter, 遵从 DDLogFormatter 协议，我们需要重写 formatLogMessage 这个方法，
 这个方法返回值是 NSString，就是最终 log 的消息体字符串
 **/

#import <Foundation/Foundation.h>
#import "PerformanceManager.h"
#import <CocoaLumberjack/DDLog.h>

@interface KKLLogFormatter : NSObject 

- (NSString *)stringFromDate:(NSDate *)date;

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage;
@end















