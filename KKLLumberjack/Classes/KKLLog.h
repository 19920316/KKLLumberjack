//
//  KKLLog.h
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/4/23.
//

#import <Foundation/Foundation.h>

#if OS_OBJECT_USE_OBJC
#define DISPATCH_QUEUE_REFERENCE_TYPE strong
#else
#define DISPATCH_QUEUE_REFERENCE_TYPE assign
#endif


@protocol KKLLoggerPro;
@protocol KKLUploadPro;


/**
 *
 每个日志附加标志, 它们与级别一起用于过滤日志
 Flags accompany each log. They are used together with levels to filter out logs.
 */
typedef NS_OPTIONS(NSUInteger, KKLLogFlag) {
    /**
     *  0...00001 DDLogFlagError
     */
    KKLLogFlagError      = (1 << 0),
    
    /**
     *  0...00010 DDLogFlagWarning
     */
    KKLLogFlagWarning    = (1 << 1),
    
    /**
     *  0...00100 DDLogFlagInfo
     */
    KKLLogFlagInfo       = (1 << 2),
    
    /**
     *  0...01000 DDLogFlagDebug
     */
    KKLLogFlagDebug      = (1 << 3),
    
    /**
     *  0...10000 DDLogFlagVerbose
     */
    KKLLogFlagVerbose    = (1 << 4)
};

/**
 *
 日志级别用于过滤日志, 与标志一起使用。
 Log levels are used to filter out logs. Used together with flags.
 */
typedef NS_ENUM(NSUInteger, KKLLogLevel) {
    /**
     *  No logs
     */
    KKLLogLevelOff       = 0,
    
    /**
     *  Error logs only
     */
    KKLLogLevelError     = (KKLLogFlagError),
    
    /**
     *  Error and warning logs
     */
    KKLLogLevelWarning   = (KKLLogLevelError   | KKLLogFlagWarning),
    
    /**
     *  Error, warning and info logs
     */
    KKLLogLevelInfo      = (KKLLogLevelWarning | KKLLogFlagInfo),
    
    /**
     *  Error, warning, info and debug logs
     */
    KKLLogLevelDebug     = (KKLLogLevelInfo    | KKLLogFlagDebug),
    
    /**
     *  Error, warning, info, debug and verbose logs
     */
    KKLLogLevelVerbose   = (KKLLogLevelDebug   | KKLLogFlagVerbose),
    
    /**
     *  All logs (1...11111)
     */
    KKLLogLevelAll       = NSUIntegerMax
};


#pragma mark ....

@protocol KKLLoggerPro <NSObject>


- (id)logger;

@end

#pragma mark ...
@protocol KKLUploadPro <NSObject>

- (void)uploadLogFileRequest:(NSData *)data block:(void (^)(void))uploadSuccess failBlock:(void (^) (id))uploadFail;

@end


@interface KKLLog : NSObject


@property (class, nonatomic, DISPATCH_QUEUE_REFERENCE_TYPE, readonly) dispatch_queue_t kklLoggingQueue;

//@property (nonatomic, DISPATCH_QUEUE_REFERENCE_TYPE, readonly) dispatch_queue_t kklLoggerQueue;

#pragma mark ...

+ (instancetype)sharedInstance;


/**
 根据服务端配置日志等级
 */
@property (nonatomic, assign) NSInteger logLevel;

/**
 error日志打印

 @param format 参数
 @param ... 多选参数
 */
extern void KKLLogError (NSString *format,...);

/**
 error和warn日志打印

 @param format 参数
 @param ... 多参
 */
extern void KKLLogWarn (NSString *format,...);

/**
 error warn 以及info日志打印

 @param format 参数
 @param ... 多参
 */
extern void KKLLogInfo (NSString *format,...);

/**
 error warn info 以及debug日志打印
 
 @param format 参数
 @param ... 多参
 */
extern void KKLLogDebug (NSString *format,...);

/**
 所有日志打印

 @param format 参数
 @param ... 多参
 */
extern void KKLLogVerbose (NSString *format,...);


/**
 添加策略
 
 @param strategy 日志记录器对应的策略
 */
- (void)addStrategy:(id <KKLLoggerPro>)strategy;


@end




