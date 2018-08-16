//
//  KKLLogUploader.h
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/5/14.
//

#import <Foundation/Foundation.h>
#import "KKLLog.h"


/**
 日志统一上报类
 */

@interface KKLLogUploader : NSObject

// 请求loader，外部注入
@property (nonatomic, strong) id <KKLUploadPro> uploader;


+ (instancetype)sharedInstance;

/**
 日志统一上报方法
 */
- (void)uploadLog;


@end
