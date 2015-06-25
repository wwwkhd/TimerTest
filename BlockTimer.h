//
//  BlockTimer.h
//  TimerTest
//
//  Created by wangwei on 15/6/25.
//  Copyright (c) 2015年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockTimer : NSObject
+(BlockTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;
+(BlockTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti userInfo:(id)userInfo repeats:(BOOL)yesOrNo queue:(dispatch_queue_t)queue block:(void(^)(void))block;
- (void)invalidate;
@end
