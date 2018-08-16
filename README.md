# KKLLumberjack

[![CI Status](http://img.shields.io/travis/yaolinhong/KKLLumberjack.svg?style=flat)](https://travis-ci.org/yaolinhong/KKLLumberjack)
[![Version](https://img.shields.io/cocoapods/v/KKLLumberjack.svg?style=flat)](http://cocoapods.org/pods/KKLLumberjack)
[![License](https://img.shields.io/cocoapods/l/KKLLumberjack.svg?style=flat)](http://cocoapods.org/pods/KKLLumberjack)
[![Platform](https://img.shields.io/cocoapods/p/KKLLumberjack.svg?style=flat)](http://cocoapods.org/pods/KKLLumberjack)
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
## Sample usage
 ///注册消息处理函数的方法
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    /// crash日志文件上报
    UploadLogFileRequest *crashLoader = [[UploadLogFileRequest alloc]init];
    [CatchCrash sharedInstance].uploader = crashLoader;
    [[CatchCrash sharedInstance] uploadCrashLogFile];
    
    ///其他日志打印和上报
    KKLTTYLoggerStrategy *ttyStrategy = [[KKLTTYLoggerStrategy alloc]init];
    
    KKLFileLoggerStrategy *fileStrategy = [[KKLFileLoggerStrategy alloc]init];
    
    KKLCountUploadLogStrategy *countStrategy = [[KKLCountUploadLogStrategy alloc]init];
    
    KKLTimeUploadLoggerStrategy *timeStrategy = [[KKLTimeUploadLoggerStrategy alloc]init];
    
    [KKLLogUploader sharedInstance].uploader = [[UploadLogFileRequest alloc]init];
    
    /// 根据服务端下发条件配置日志
    [KKLLog sharedInstance].logLevel = [KKLConfigCenterServer sharedInstance].logDefaultLogLevel;
    countStrategy.logCount = [KKLConfigCenterServer sharedInstance].logUploadCacheArticles;
    fileStrategy.kLogFileSize = [KKLConfigCenterServer sharedInstance].logCacheUploadMaxSize;
    timeStrategy.logUploadInterval = [KKLConfigCenterServer sharedInstance].logUploadPeriod;
    
    [[KKLLog sharedInstance] addStrategy:ttyStrategy];
    [[KKLLog sharedInstance] addStrategy:fileStrategy];
    [[KKLLog sharedInstance] addStrategy:countStrategy];
    [[KKLLog sharedInstance] addStrategy:timeStrategy];

## Requirements

## Installation

KKLLumberjack is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KKLLumberjack'
```

## Author

sheepWhite

## License

KKLLumberjack is available under the MIT license. See the LICENSE file for more info.
