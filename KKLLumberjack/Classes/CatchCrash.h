//
//  CatchCrash.h
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/4/17.
//

/*
 抓取崩溃 log 记录下崩溃，并在APP下次启动上传
 **/

#import <Foundation/Foundation.h>
#import "KKLLog.h"


@interface CatchCrash : NSObject

// 上传器
@property (nonatomic, strong) id<KKLUploadPro> uploader;

+ (instancetype)sharedInstance;


void uncaughtExceptionHandler(NSException *exception);

#pragma mark 上传crash文件
- (void)uploadCrashLogFile;

@end
