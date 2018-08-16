//
//  KKLFileLogger.m
//  TestDemo
//
//  Created by 张丽 on 2018/5/11.
//  Copyright © 2018年 张丽. All rights reserved.
//

#import "KKLFileLogger.h"
#import "KKLLogFormatter.h"
#import "CocoaLumberjack.h"

//static const  NSInteger kLogFileSize = 52428800;//3072;//5242880;//目前最大总文件大小是50M

static dispatch_queue_t _fileLoggerQueue;

@interface KKLFileLogger() <DDLogger>

@property (nonatomic, strong) DDFileLogger *logger;

@property (nonatomic, DISPATCH_QUEUE_REFERENCE_TYPE, readonly) dispatch_queue_t fileLoggerQueue;


@end

@implementation KKLFileLogger

@synthesize logFormatter = _logFormatter;

- (instancetype)init {
    if (self = [super init]) {
        
        _fileLoggerQueue = dispatch_queue_create("kklFileLogger.lumberjack", DISPATCH_QUEUE_SERIAL);
        
        _logger = [[DDFileLogger alloc ] init];
        _logger.logFormatter = [[KKLLogFormatter alloc]init];
        _logger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        _logger.logFileManager.maximumNumberOfLogFiles = 7;
    }
    return self;
}
- (void)setKLogFileSize:(NSInteger)kLogFileSize {
    _kLogFileSize = kLogFileSize;
    _logger.maximumFileSize = kLogFileSize;
}
- (void)logMessage:(DDLogMessage *)logMessage {
    dispatch_queue_t loggerQueue = self.fileLoggerQueue;
    
    dispatch_async(loggerQueue, ^{
        [self willWrite];
        [self writeWithString:logMessage->_message];
        [self.logger logMessage:logMessage];
        [self didWrite];
    });
}
#pragma mark ...
- (NSArray *)kklSortedLogFileInfos {
   return  [self.logger.logFileManager sortedLogFileInfos];
}
- (void)kklRollLogFileWithCompletionBlock:(void (^) (void)) rollLogFileWithCompletionBlock {
    [self.logger rollLogFileWithCompletionBlock:^{
        if (rollLogFileWithCompletionBlock) {
            rollLogFileWithCompletionBlock();
        }
    }];
}
- (id<DDLogFormatter>)logFormatter {
    return self.logger.logFormatter;
}

- (void)willWrite {
//    NSLog(@"%s", __func__);
}

- (void)writeWithString:(NSString *)string {
//    NSLog(@"%s %@", __func__, string);
}

- (void)didWrite {
//    NSLog(@"%s", __func__);
}

@end
