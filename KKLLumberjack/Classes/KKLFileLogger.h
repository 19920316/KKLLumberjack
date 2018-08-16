//
//  KKLFileLogger.h
//  TestDemo
//
//  Created by 张丽 on 2018/5/11.
//  Copyright © 2018年 张丽. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KKLFileLogger : NSObject 

/**
 日志总缓存大小
 */
@property (nonatomic, assign) NSInteger kLogFileSize;

/**
 日志文件排序

 @return 日志文件
 */
- (NSArray *)kklSortedLogFileInfos;

/**
  我们需要在我们的日志线程/队列上执行滚动。

 @param rollLogFileWithCompletionBlock 指定新文件后的操作
 */
- (void)kklRollLogFileWithCompletionBlock:(void (^) (void)) rollLogFileWithCompletionBlock;
@end
