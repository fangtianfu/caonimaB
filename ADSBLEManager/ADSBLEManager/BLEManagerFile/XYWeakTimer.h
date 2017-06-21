//
//  XYWeakTimer.h
//  Demo
//
//  Created by Adsmart on 16/6/1.
//  Copyright © 2016年 why. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TimerBlock)(NSTimer * timer);

@interface XYWeakTimer : NSProxy

+ (NSTimer *)scheduledTimerWithTime:(NSTimer *)timer interval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats;

+ (NSTimer *)scheduledTimerWithTime:(NSTimer *)timer interval:(NSTimeInterval)interval target:(id)target timerBlock:(TimerBlock)timerBlock userInfo:(id)userInfo repeats:(BOOL)repeats;

@end
