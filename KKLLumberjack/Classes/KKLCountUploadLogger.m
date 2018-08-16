//
//  KKLUploadLogger.m
//  TestDemo
//
//  Created by 张丽 on 2018/5/11.
//  Copyright © 2018年 张丽. All rights reserved.
//

#import "KKLCountUploadLogger.h"
#import "CocoaLumberjack.h"
#import "KKLLogUploader.h"


static dispatch_queue_t _countLoggerQueue;

@interface KKLCountUploadLogger() <DDLogger>

@property (nonatomic, DISPATCH_QUEUE_REFERENCE_TYPE, readonly) dispatch_queue_t countLoggerQueue;

@property (nonatomic, strong) KKLLogUploader *uploader;

@end

@implementation KKLCountUploadLogger

@synthesize logFormatter = _logFormatter;

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _countLoggerQueue = dispatch_queue_create("kklCountLogger.lumberjack", DISPATCH_QUEUE_SERIAL);
        
        _uploader = [KKLLogUploader sharedInstance];
    }
    return self;
}

- (void)logMessage:(DDLogMessage *)logMessage {
    dispatch_queue_t loggerQueue = self.countLoggerQueue;
    
    dispatch_async(loggerQueue, ^{
        [self willWrite];
        [self writeWithString:logMessage->_message];
        [self didWrite];
    });
}

- (void)willWrite {
//    NSLog(@"%s", __func__);
    self.count ++;
}

- (void)writeWithString:(NSString *)string {
//    NSLog(@"%s %@", __func__, string);
}

- (void)didWrite {
//    NSLog(@"%s", __func__);
    if (self.count >= self.logCount) {
        /// 满足日志上报条件，上报日志
        dispatch_queue_t globalLoggingQueue = [KKLLog kklLoggingQueue];
    
        dispatch_async(globalLoggingQueue, ^{
            [self.uploader uploadLog];
        });
    }
}

@end
