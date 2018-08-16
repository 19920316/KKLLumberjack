//
//  KKLFileLogStrage.m
//  TestDemo
//
//  Created by 昭荣伊 on 2018/5/11.
//  Copyright © 2018年 昭荣伊. All rights reserved.
//

#import "KKLFileLoggerStrategy.h"
#import "KKLFileLogger.h"


@interface KKLFileLoggerStrategy ()

@property (nonatomic, strong) KKLFileLogger *logger;

@end

@implementation KKLFileLoggerStrategy

- (instancetype)init {
    if (self = [super init]) {
        _logger = [KKLFileLogger new];
    }
    return self;
}

- (void)setKLogFileSize:(NSInteger)kLogFileSize {
    _kLogFileSize = kLogFileSize;
    _logger.kLogFileSize = kLogFileSize;
    if (kLogFileSize <= 0) {
        _logger.kLogFileSize = 5242880;//5 M
    }
}
- (id)logger {
    return _logger;
}

@end
