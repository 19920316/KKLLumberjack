//
//  KKLUploadLogger.h
//  TestDemo
//
//  Created by 张丽 on 2018/5/11.
//  Copyright © 2018年 张丽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKLCountUploadLogger : NSObject 

/// 服务端配置打印日志条数
@property (nonatomic, assign) NSInteger logCount;

/// 记录打印日志条数
@property (nonatomic, assign) NSInteger count;

+ (instancetype)sharedInstance;;

@end
