//
//  CatchCrash.m
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/4/17.
//

#import <CatchCrash.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "DeviceManager.h"


#define DirectorCrashPath [NSString stringWithFormat:@"%@/Documents/kklCrash.log", NSHomeDirectory()]


@implementation CatchCrash

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


//在AppDelegate中注册后，程序崩溃时会执行的方法
void uncaughtExceptionHandler(NSException *exception) {
    //获取系统当前时间，（注：用[NSDate date]直接获取的是格林尼治时间，有时差）
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *crashTime = [formatter stringFromDate:[NSDate date]];
    //异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    //出现异常的原因
    NSString *reason = [exception reason];
    //异常名称
    NSString *name = [exception name];
    
    //拼接错误信息
    NSString *exceptionInfo = [NSString stringWithFormat:@"崩溃时间: %@ 崩溃原因: %@\n崩溃方法名字: %@\n崩溃堆栈信息:%@", crashTime, name, reason, stackArray];
    
    //把错误信息保存到本地文件，设置errorLogPath路径下,等待APP下次启动选择上传到服务器
    NSError *error = nil;
    
    NSString *path = [DirectorCrashPath stringByAppendingString:crashTime];
    BOOL isSuccess = [exceptionInfo writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (!isSuccess) {
        KKLLogError(@"将crash信息保存到本地失败: %@", error.userInfo);
    }
}

#pragma mark 上传crash文件
- (void)uploadCrashLogFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()] isDirectory:&isDir];
//    NSLog(@"崩溃文件路径 ==== %@",[NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()]);
    if (isExist) {
        NSArray * errorArray = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()] error:nil];
        for (NSString *str in errorArray) {
            if ([str rangeOfString:@"kklCrash"].location != NSNotFound) {
                NSString *filePath = [[NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()] stringByAppendingPathComponent:str];
                BOOL exist = [fileManager fileExistsAtPath:filePath];
                if (exist) {
                    NSData *logData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingUncached error:nil];
                    if ([self.uploader respondsToSelector:@selector(uploadLogFileRequest:block:failBlock:)]) {
                        [self.uploader uploadLogFileRequest:logData block:^{
                            NSError *error = nil;
                            BOOL remove = [fileManager removeItemAtPath:filePath error:&error];
                            if (!remove) {
                                KKLLogError(@"移除崩溃文件失败:%@", error);
                            }
                        } failBlock:^(id msg) {
                            KKLLogError(@"上传文件失败:%@", msg);
                        }];
                    }
                }
            }
        }
    }
    else{
        KKLLogError(@"this path is not exist!");
    }
}





@end


























