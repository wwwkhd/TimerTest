//
//  BlockTimer.m
//  TimerTest
//
//  Created by wangwei on 15/6/25.
//  Copyright (c) 2015年 wangwei. All rights reserved.
//

#import "BlockTimer.h"

typedef void(^ TimerBlock) (void);

@implementation BlockTimer
{
    dispatch_source_t timer;
    TimerBlock _block;
}

+(BlockTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    
    BlockTimer *blocktimer = [[BlockTimer alloc] init];
    [blocktimer addTimer:ti target:aTarget selector:aSelector queue:dispatch_get_main_queue() block:NULL userInfo:userInfo repeats:yesOrNo];
    
    
    return blocktimer;
}


+(BlockTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti userInfo:(id)userInfo repeats:(BOOL)yesOrNo queue:(dispatch_queue_t)queue block:(void(^)(void))block
{
    BlockTimer *blocktimer = [[BlockTimer alloc] init];
    
    [blocktimer addTimer:ti target:nil selector:nil queue:queue block:block userInfo:userInfo repeats:yesOrNo];
    
    
    return blocktimer;
}

- (void) addTimer:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector queue:(dispatch_queue_t)queue block:(TimerBlock)block userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    dispatch_queue_t _queue = queue;
    if (!_queue) {
        _queue = dispatch_queue_create("timerqueue", NULL);
    }
    
    dispatch_queue_t _sourcequeue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _sourcequeue);
    if (yesOrNo) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), ti * NSEC_PER_SEC, 0);
    }else{
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), DISPATCH_TIME_FOREVER, 0);
    }
    
    if (block) {
        _block = block;
        dispatch_source_set_event_handler(timer,^{
            dispatch_async(_queue, _block);
        });
    }else{
        __weak id _target = aTarget;
        SEL _timerAction = aSelector;
        _block = ^{
            
            if (_target && [_target respondsToSelector:_timerAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_target performSelector:_timerAction withObject:nil];
#pragma clang diagnostic pop
                
            }
        };
        
        dispatch_source_set_event_handler(timer,^{
            dispatch_async(_queue, _block);
        });
    }
    
    dispatch_resume(timer);
}

- (void)invalidate
{
    if (timer) {
        dispatch_source_cancel(timer);
    }
}
@end
