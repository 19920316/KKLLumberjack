//
//  KKLLogUploader.m
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/5/14.
//

#import "KKLLogUploader.h"
#import "CocoaLumberjack.h"
#import "KKLFileLogger.h"
#import "KKLCountUploadLogger.h"

@interface KKLLogUploader ()

@property (nonatomic, strong) KKLFileLogger *fileLogger;
//@property (nonatomic, assign) NSUInteger logCount;

@end

@implementation KKLLogUploader

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
        _fileLogger = [[KKLFileLogger alloc]init];
    }
    return self;
}

- (void)uploadLog {
    
    NSArray *sortedLogFileInfos = [_fileLogger kklSortedLogFileInfos];
    
    __weak __typeof(self)weakSelf = self;
    
    [_fileLogger kklRollLogFileWithCompletionBlock:^{
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        // 置空本地记录的日志条数
//        strongSelf.logCount = [KKLCountUploadLogger sharedInstance].count;
//        NSLog(@"本地日志条数 --- %ld",[KKLCountUploadLogger sharedInstance].count);
//        NSDate *data = [NSDate dateWithTimeIntervalSinceNow:0];
//        NSTimeInterval terval = [data timeIntervalSince1970];
//        NSString *timeString = [NSString stringWithFormat:@"%0.f", terval];//转为字符型
//        NSLog(@"日志上报当前时间戳 ---- %@",timeString);
        [KKLCountUploadLogger sharedInstance].count = 0;
        
        if (sortedLogFileInfos.count) {
            for (NSInteger i = 0; i < sortedLogFileInfos.count; i++) {
                
                NSString *filePath = [sortedLogFileInfos[i] filePath];
                NSData *data = [NSData dataWithContentsOfFile:filePath];
                if (!data || data.length == 0)  {
                    continue;
                }
                // create 信号量
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//                NSLog(@"qian");
                // 上传
                [strongSelf.uploader uploadLogFileRequest:data block:^{
//                    NSLog(@"zhong");
                    // 移除
                    dispatch_semaphore_signal(semaphore);
                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                } failBlock:^(id msg) {
                    dispatch_semaphore_signal(semaphore);
                }];
                // wait
                dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
//                NSLog(@"继续执行");
            }
        }
    }];
}



@end
