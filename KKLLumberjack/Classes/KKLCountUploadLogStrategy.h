//
//  KKLUploadLogStrage.h
//  TestDemo
//
//  Created by 昭荣伊 on 2018/5/11.
//  Copyright © 2018年 昭荣伊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKLLog.h"

@interface KKLCountUploadLogStrategy : NSObject <KKLLoggerPro>


/**
 配置满足日志上报条件的日志数量
 */
@property (nonatomic, assign) NSInteger logCount;

@end
