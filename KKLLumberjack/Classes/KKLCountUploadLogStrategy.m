//
//  KKLUploadLogStrage.m
//  TestDemo
//
//  Created by 昭荣伊 on 2018/5/11.
//  Copyright © 2018年 昭荣伊. All rights reserved.
//

#import "KKLCountUploadLogStrategy.h"
#import "KKLCountUploadLogger.h"

@implementation KKLCountUploadLogStrategy


- (id)logger {
    return [KKLCountUploadLogger sharedInstance];
}
- (void)setLogCount:(NSInteger)logCount {
    _logCount = logCount;
    [KKLCountUploadLogger sharedInstance].logCount = logCount;
    if (logCount <= 0) {
        [KKLCountUploadLogger sharedInstance].logCount = 1000;
    }
}
@end
