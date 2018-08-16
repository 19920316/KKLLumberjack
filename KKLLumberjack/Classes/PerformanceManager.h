//
//  PerformanceManager.h
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/4/11.
//

#import <Foundation/Foundation.h>
#import "KKLLog.h"

struct    tcpstat {
    u_long    tcps_connattempt;    /* connections initiated */
    u_long    tcps_accepts;        /* connections accepted */
    u_long    tcps_connects;        /* connections established */
    u_long    tcps_drops;        /* connections dropped */
    u_long    tcps_conndrops;        /* embryonic connections dropped */
    u_long    tcps_closed;        /* conn. closed (includes drops) */
    u_long    tcps_segstimed;        /* segs where we tried to get rtt */
    u_long    tcps_rttupdated;    /* times we succeeded */
    u_long    tcps_delack;        /* delayed acks sent */
    u_long    tcps_timeoutdrop;    /* conn. dropped in rxmt timeout */
    u_long    tcps_rexmttimeo;    /* retransmit timeouts */
    u_long    tcps_persisttimeo;    /* persist timeouts */
    u_long    tcps_keeptimeo;        /* keepalive timeouts */
    u_long    tcps_keepprobe;        /* keepalive probes sent */
    u_long    tcps_keepdrops;        /* connections dropped in keepalive */
    
    u_long    tcps_sndtotal;        /* total packets sent */
    u_long    tcps_sndpack;        /* data packets sent */
    u_long    tcps_sndbyte;        /* data bytes sent */
    u_long    tcps_sndrexmitpack;    /* data packets retransmitted */
    u_long    tcps_sndrexmitbyte;    /* data bytes retransmitted */
    u_long    tcps_sndacks;        /* ack-only packets sent */
    u_long    tcps_sndprobe;        /* window probes sent */
    u_long    tcps_sndurg;        /* packets sent with URG only */
    u_long    tcps_sndwinup;        /* window update-only packets sent */
    u_long    tcps_sndctrl;        /* control (SYN|FIN|RST) packets sent */
    
    u_long    tcps_rcvtotal;        /* total packets received */
    u_long    tcps_rcvpack;        /* packets received in sequence */
    u_long    tcps_rcvbyte;        /* bytes received in sequence */
    u_long    tcps_rcvbadsum;        /* packets received with ccksum errs */
    u_long    tcps_rcvbadoff;        /* packets received with bad offset */
    u_long    tcps_rcvshort;        /* packets received too short */
    u_long    tcps_rcvduppack;    /* duplicate-only packets received */
    u_long    tcps_rcvdupbyte;    /* duplicate-only bytes received */
    u_long    tcps_rcvpartduppack;    /* packets with some duplicate data */
    u_long    tcps_rcvpartdupbyte;    /* dup. bytes in part-dup. packets */
    u_long    tcps_rcvoopack;        /* out-of-order packets received */
    u_long    tcps_rcvoobyte;        /* out-of-order bytes received */
    u_long    tcps_rcvpackafterwin;    /* packets with data after window */
    u_long    tcps_rcvbyteafterwin;    /* bytes rcvd after window */
    u_long    tcps_rcvafterclose;    /* packets rcvd after "close" */
    u_long    tcps_rcvwinprobe;    /* rcvd window probe packets */
    u_long    tcps_rcvdupack;        /* rcvd duplicate acks */
    u_long    tcps_rcvacktoomuch;    /* rcvd acks for unsent data */
    u_long    tcps_rcvackpack;    /* rcvd ack packets */
    u_long    tcps_rcvackbyte;    /* bytes acked by rcvd acks */
    u_long    tcps_rcvwinupd;        /* rcvd window update packets */
};

@interface PerformanceManager : NSObject {
    size_t oldSentBytes;
    size_t oldRecvBytes;
}
/// FPS值
@property (nonatomic, assign) NSInteger fps;

+ (instancetype)sharedInstance;

#pragma mark ... 系统运行时间
/**
 系统正常运行时间

 @return 运行时间
 */
- (NSDate *)systemUptime;

#pragma mark ... CPU
/**
 当前应用CPU占用 --- 帮助链接 https://github.com/aozhimin/iOS-Monitor-Platform

 @return CPU占用
 */
- (CGFloat)getApplicationCpuUsage;

/**
 总设备的CPU占用率

 @return CPU占用率
 */
- (CGFloat)cpuUsage;

#pragma mark ... 磁盘空间
/**
 磁盘空间

 @return 磁盘总大小
 */
- (float)diskSpace;

/**
 磁盘剩余空间

 @return 剩余大小
 */
- (float)diskSpaceFree;

/**
 磁盘已用空间

 @return 已经使用大小
 */
- (float)diskSpaceUsed ;

#pragma mark .... 运存空间
/**
 获取当前应用内存占用

 @return 内存占用
 */
- (NSInteger)getResidentMemory;

/**
 获取设备的 Memory 使用情况

 @return 设备的 Memory 占用
 */
- (int64_t)getUsedMemory;

/**
 获取设备可用的内存

 @return 剩余内存
 */
- (int64_t)availableMemory;

#pragma mark .... 电量获取(精确相差 < %5)
/**
 电池电量获取 --- 帮助链接：https://www.jianshu.com/p/11c1afdf5415

 @return 电池电量
 */
- (int)getCurrentBatteryLevel;

#pragma mark FPS的监测和卡顿监测
/**
 FPS的监测开启
 */
- (void)startLink;

/**
 FPS监测暂停
 */
- (void)destroyLink;

/**
 开启卡顿监测
 */
- (void)start;

/**
 关闭卡顿监测
 */
- (void)stop;












@end




























