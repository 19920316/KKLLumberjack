//
//  KKLFileLogStrage.h
//  TestDemo
//
//  Created by 昭荣伊 on 2018/5/11.
//  Copyright © 2018年 昭荣伊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKLLog.h"

@interface KKLFileLoggerStrategy : NSObject <KKLLoggerPro>

/**
 日志总缓存大小
 */
@property (nonatomic, assign) NSInteger kLogFileSize;

@end
