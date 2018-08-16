//
//  KKLTTYLoggerStrategy.m
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/4/28.
//

#import "KKLTTYLoggerStrategy.h"
 #import <CocoaLumberjack/CocoaLumberjack.h>

@implementation KKLTTYLoggerStrategy


- (id)logger {
    return [DDTTYLogger sharedInstance];
}

@end
