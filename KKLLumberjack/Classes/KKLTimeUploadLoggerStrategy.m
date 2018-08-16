//
//  KKLTimeUploadLoggerStrategy.m
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/5/14.
//

#import "KKLTimeUploadLoggerStrategy.h"
#import "KKLTimeUploadLogger.h"

@interface KKLTimeUploadLoggerStrategy ()

@property (nonatomic, strong) KKLTimeUploadLogger *timeUploaderLogger;

@end

@implementation KKLTimeUploadLoggerStrategy


- (instancetype)init {
    self = [super init];
    if (self) {
         _timeUploaderLogger = [[KKLTimeUploadLogger alloc]init];
    }
    return self;
}

- (id)logger {
    return _timeUploaderLogger;
}
- (void)setLogUploadInterval:(NSInteger)logUploadInterval {
    _logUploadInterval = logUploadInterval;
    _timeUploaderLogger.logUploadInterval = logUploadInterval;
    if (logUploadInterval <= 0) {
        _timeUploaderLogger.logUploadInterval = 60*10;//10分钟
    }
}
@end
