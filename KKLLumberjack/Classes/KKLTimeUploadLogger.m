//
//  KKLTimeUploadLogger.m
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/5/14.
//

#import "KKLTimeUploadLogger.h"
#import "KKLLumberjack.h"
#import "CocoaLumberjack.h"

//static const NSInteger logUploadInterval = 60*5;//日志时间上报间隔

@interface KKLTimeUploadLogger () <DDLogger>

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) KKLLogUploader *uploader;
@end

@implementation KKLTimeUploadLogger

@synthesize logFormatter = _logFormatter;


- (void)logMessage:(DDLogMessage *)logMessage {
//    NSLog(@"%s",__func__);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _uploader = [KKLLogUploader sharedInstance];
    }
    return self;
}
- (void)setLogUploadInterval:(NSInteger)logUploadInterval {
    _logUploadInterval = logUploadInterval;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:logUploadInterval target:self selector:@selector(uploadLogWithInterval) userInfo:nil repeats:YES];
    self.timer = timer;
}
#pragma mark 时间日志上报策略
- (void)uploadLogWithInterval {
    dispatch_queue_t globalLoggingQueue = [KKLLog kklLoggingQueue];
    dispatch_async(globalLoggingQueue, ^{
        [self.uploader uploadLog];
    });
}
@end



















