//
//  KKLTimeUploadLoggerStrategy.h
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/5/14.
//

#import <Foundation/Foundation.h>
#import "KKLLog.h"

@interface KKLTimeUploadLoggerStrategy : NSObject <KKLLoggerPro>

/**
 日志上报周期
 */
@property (nonatomic, assign) NSInteger logUploadInterval;

@end
