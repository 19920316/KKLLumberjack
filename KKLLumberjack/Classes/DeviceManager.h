//
//  DeviceManager.h
//  KKLLumberjack
//
//  Created by 张丽 on 2018/4/11.
//

#import <Foundation/Foundation.h>

@interface DeviceManager : NSObject

+ (instancetype)sharedInstance;

/// 设备uuid
@property (nonatomic, strong) NSString *uuid;

/**
 获取APP版本号

 @return 当前应用版本号
 */
@property (nonatomic, strong) NSString *version;

/**
 平台

 @return iOS为1，android为2
 */
@property (nonatomic, strong) NSString *platform;

/**
 手机操作系统版本

 @return 最长为1024
 */
@property (nonatomic, strong) NSString *osVersion;

/**
 唯一标识符

 @return 报名，最长1024
 */
@property (nonatomic, strong) NSString *bundleIdentifier;

/**
 用户ID

 @return 最长1024
 */
@property (nonatomic, strong) NSString *userToken;

/**
 手机品牌

 @return 最长1024
 */
@property (nonatomic, strong) NSString *brand;

/**
 手机屏幕尺寸的获取

 @return 尺寸大小，最长1024
 */
@property (nonatomic, strong) NSString *resolution;

/**
 APP安装来源

 @return 最长512
 */
@property (nonatomic, strong) NSString *channel;

/**
 手机型号

 @return 最长128
 */
@property (nonatomic, strong) NSString *deviceModel;

/**
 国际手机唯一标识码

 @return 最长512
 */
@property (nonatomic, strong) NSString *imei;

/**
 用户账号

 @return 最长128
 */
@property (nonatomic, strong) NSString *userAccount;

/**
 设备机型

 @return 设备机型
 */
- (NSString *)iphoneType;
@end






















