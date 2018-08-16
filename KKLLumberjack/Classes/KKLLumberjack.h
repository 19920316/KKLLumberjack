//
//  KKLLumberjack.h
//  Pods
//
//  Created by 张丽 on 2018/4/18.
//

//#ifndef KKLLumberjack_h
#define KKLLumberjack_h
#import "KKLLog.h"
#import "CatchCrash.h"
#import "KKLCountUploadLogger.h"
#import "KKLFileLoggerStrategy.h"
#import "KKLTTYLoggerStrategy.h"
#import "KKLCountUploadLogStrategy.h"
#import "KKLTimeUploadLoggerStrategy.h"
#import "KKLFileLogger.h"
#import "KKLLogUploader.h"

//通过DEBUG模式设置全局日志等级，DEBUG时为Verbose，所有日志信息都可以打印，否则Error，只打印
#ifdef DEBUG
static const KKLLogLevel kklLogLevel = KKLLogLevelVerbose;
#else
static const KKLLogLevel kklLogLevel = KKLLogLevelError;
#endif


//#ifdef DEBUG
//#define KKLLog(format, ...) KKLLogError((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#define DLog(...);
//#endif



//#endif /* KKLLumberjack_h */

