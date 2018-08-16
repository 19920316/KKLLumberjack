//
//  PerformanceManager.m
//  CocoaLumberjack
//
//  Created by 张丽 on 2018/4/11.
//

#import "PerformanceManager.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <objc/runtime.h>
#import <CrashReporter/CrashReporter.h>
#import "KKLLumberjack.h"

#import "DeviceManager.h"

@interface PerformanceManager () {
    NSUInteger _count;
    NSTimeInterval _lastTime;
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
    CFRunLoopObserverRef observer;
    int timeoutCount;
}

@property (nonatomic, strong) CADisplayLink *link;

@property (nonatomic, strong) dispatch_queue_t fpsQueue;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) float diskSpace;

@property (nonatomic, assign) float diskSpaceFree;

@property (nonatomic, assign) BOOL didBecomeActive;

@end

@implementation PerformanceManager

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance startLink];
    });
    
    return sharedInstance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.fpsQueue = dispatch_queue_create("fps.performance.ConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
//        NSString *deviceModel = [[DeviceManager sharedInstance] iphoneType];
//        if ([deviceModel isEqualToString:@"iPhone 6 Plus"] || [deviceModel isEqualToString:@"iPhone 6"] || [deviceModel isEqualToString:@"iPhone 6s"] || [deviceModel isEqualToString:@"iPhone 6s Plus"] || [deviceModel isEqualToString:@"iPhone 7"] || [deviceModel isEqualToString:@"iPhone 7 Plus"] ) {
//            [self start];
//        }
    }
    return self;
}
#pragma mark 系统运行时间
- (NSDate *)systemUptime {
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    return [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
}
#pragma mark 当前应用CPU反馈
- (CGFloat)getApplicationCpuUsage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    for (j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        basic_info_th = (thread_basic_info_t)thinfo;
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
    } // for each thread
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    return tot_cpu;
//    NSLog(@"CPU Usage: %f \n", tot_cpu);
}
#pragma mark 总设备的CPU占用率
- (CGFloat)cpuUsage {
    kern_return_t kr;
    mach_msg_type_number_t count;
    static host_cpu_load_info_data_t previous_info = {0, 0, 0, 0};
    host_cpu_load_info_data_t info;
    
    count = HOST_CPU_LOAD_INFO_COUNT;
    
    kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&info, &count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    natural_t user   = info.cpu_ticks[CPU_STATE_USER] - previous_info.cpu_ticks[CPU_STATE_USER];
    natural_t nice   = info.cpu_ticks[CPU_STATE_NICE] - previous_info.cpu_ticks[CPU_STATE_NICE];
    natural_t system = info.cpu_ticks[CPU_STATE_SYSTEM] - previous_info.cpu_ticks[CPU_STATE_SYSTEM];
    natural_t idle   = info.cpu_ticks[CPU_STATE_IDLE] - previous_info.cpu_ticks[CPU_STATE_IDLE];
    natural_t total  = user + nice + system + idle;
    previous_info    = info;
    
    return (user + nice + system) * 100.0 / total;
}
#pragma mark CPU核数
- (NSUInteger)cpuNumber {
    return [NSProcessInfo processInfo].activeProcessorCount;
}

#pragma mark 磁盘空间 (单位:G)
- (float)diskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    NSNumber *_total = [attrs objectForKey:NSFileSystemSize];
    float space = [_total unsignedLongLongValue]*1.0/(1024);
    space = space/1024.0/1024.0;
    if (space < 0) space = -1;
    self.diskSpace = space;
    return space;
}

- (float)diskSpaceFree {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    NSNumber  *free =  [attrs objectForKey:NSFileSystemFreeSize];
    float spaceFree = [free unsignedLongLongValue]*1.0/(1024);
    spaceFree = spaceFree/1024.0/1024.0;
    if (spaceFree < 0) spaceFree = -1;
    self.diskSpaceFree = spaceFree;
    return spaceFree;
}

- (float)diskSpaceUsed {
    float total = self.diskSpace;
    float free = self.diskSpaceFree;
    if (total < 0 || free < 0) return -1;
    float used = total - free;
    if (used < 0) used = -1;
    return used;
}
#pragma mark .........
#pragma mark 获取当前应用的运存
- (NSInteger)getResidentMemory {
    struct mach_task_basic_info info;
    mach_msg_type_number_t count = MACH_TASK_BASIC_INFO_COUNT;
    
    int r = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t) &info, &count);
    if ( r == KERN_SUCCESS) {
        return info.resident_size;
    }
    return -1;
}
#pragma mark 获取当前设备的 Memory 使用情况
- (int64_t)getUsedMemory {
    size_t length = 0;
    int mib[6] = {0};
    
    int pagesize = 0;
    mib[0] = CTL_HW;
    mib[1] = HW_PAGESIZE;
    length = sizeof(pagesize);
    if (sysctl(mib, 2, &pagesize, &length, NULL, 0) < 0)
    {
        return 0;
    }
    
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    
    vm_statistics_data_t vmstat;
    
    if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) != KERN_SUCCESS) {
        return 0;
    }
    
    int wireMem = vmstat.wire_count * pagesize;
    int activeMem = vmstat.active_count * pagesize;
    return wireMem + activeMem;
}
#pragma mark 获取设备可用的运存（单位：byte）
- (int64_t)availableMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}
#pragma mark 电池电量及时反馈
- (int)getCurrentBatteryLevel {
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState == UIApplicationStateActive||app.applicationState==UIApplicationStateInactive) {
        Ivar ivar=  class_getInstanceVariable([app class],"_statusBar");
        id status  = object_getIvar(app, ivar);
        for (id aview in [status subviews]) {
            int batteryLevel = 0;
            for (id bview in [aview subviews]) {
                if ([NSStringFromClass([bview class]) caseInsensitiveCompare:@"UIStatusBarBatteryItemView"] == NSOrderedSame&&[[[UIDevice currentDevice] systemVersion] floatValue] >=6.0) {
                    Ivar ivar=  class_getInstanceVariable([bview class],"_capacity");
                    if(ivar) {
                        batteryLevel = ((int (*)(id, Ivar))object_getIvar)(bview, ivar);
                        //这种方式也可以
                        /*ptrdiff_t offset = ivar_getOffset(ivar);
                         unsigned char *stuffBytes = (unsigned char *)(__bridge void *)bview;
                         batteryLevel = * ((int *)(stuffBytes + offset));*/
//                        NSLog(@"电池电量:%d",batteryLevel);
                        if (batteryLevel > 0 && batteryLevel <= 100) {
                            return batteryLevel;
                        } else {
                            return 0;
                        }
                    }
                }
            }
        }
    }
    return 0;
}

#pragma mark FPS的获取条件初始化
/*
 值得注意的是基于CADisplayLink实现的 FPS 在生产场景中只有指导意义，不能代表真实的 FPS，
 因为基于CADisplayLink实现的 FPS 无法完全检测出当前 Core Animation 的性能情况，
 它只能检测出当前 RunLoop 的帧率。
 */
- (void)startLink {
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [self->_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    });
}
- (void)tick:(CADisplayLink *)link{
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return ;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return ;
    NSTimeInterval currentLastTime = link.timestamp;
    dispatch_async(self.fpsQueue, ^{
        self->_lastTime = currentLastTime;
        NSInteger fps = self->_count / delta;
       self->_count = 0;
        @synchronized (self) {
            self.fps = fps;
        }
    });
}
- (void)destroyLink {
    _link.paused = YES;
    [_link invalidate];
    _link = nil;
}

#pragma mark 卡顿监测关闭
- (void)stop {
    if (!observer)
        return;
    if(self.timer) {
        // 关闭GCD定时器
        dispatch_source_set_cancel_handler(self.timer, ^{
            
        });
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
}
#pragma mark  线程的卡顿情况监测
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    PerformanceManager *manager = (__bridge PerformanceManager*)info;
    // 记录状态值
    manager->activity = activity;
    // 发送信号
    dispatch_semaphore_t semaphore = manager->semaphore;
    dispatch_semaphore_signal(semaphore);
}
- (void)registerNotifi {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(someMethod:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)someMethod:(NSNotification *)notifi {
    self.didBecomeActive = YES;
}
#pragma mark 卡顿监测开启
- (void)start {
    [self registerNotifi];
    if (observer)
    return;
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    // 创建信号
    semaphore = dispatch_semaphore_create(0);
    
//     __block CFRunLoopObserverRef weakObserver = observer;
//    __block  dispatch_semaphore_t weakSemphore = semaphore;
//    __block  int weakTimeoutCount = timeoutCount;
//    __block  CFRunLoopActivity weakActivity = activity;
    // 在子线程监控时长
     dispatch_queue_t queue = dispatch_queue_create("log.performance.ConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        while (YES) {
            // 假定连续5次超时50ms认为卡顿(当然也包含了单次超时250ms)
            long st = dispatch_semaphore_wait(self->semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            if (st != 0 && self.didBecomeActive == YES ) {
                if (self->activity == kCFRunLoopBeforeSources || self->activity == kCFRunLoopAfterWaiting) {
                    if (++self->timeoutCount < 5)
                        continue;
                    // 监控到了卡顿现场,当然下一步便是记录此时的函数调用信息,此处可以使用一个第三方Crash收集组件PLCrashReporter,它不仅可以收集Crash信息也可用于实时获取各线程的调用堆栈,使用示例如下:
                    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
                                                                                       symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
                    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
                    
                    NSData *data = [crashReporter generateLiveReport];
                    PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
                    NSString *report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter
                                                                              withTextFormat:PLCrashReportTextFormatiOS];
                    KKLLogError(@"上报卡顿信息----%d-----\n%@\n------------",self->timeoutCount,report);
                }
            }
            self->timeoutCount = 0;
        }
    });
}

- (void)dealloc {
    [self destroyLink];
    [self stop];
}















@end
