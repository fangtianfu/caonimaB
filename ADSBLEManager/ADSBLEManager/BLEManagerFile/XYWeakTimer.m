//
//  XYWeakTimer.m
//  Demo
//
//  Created by Adsmart on 16/6/1.
//  Copyright © 2016年 why. All rights reserved.
//

#import "XYWeakTimer.h"

@interface XYProxy : NSProxy

@property (nonatomic,assign)SEL selector;

@property (nonatomic,copy)TimerBlock block;

@property (nonatomic,weak)NSTimer *timer;

@property (nonatomic,weak)id target;

@end

@implementation XYProxy

- (void)responseTimer:(NSTimer *)timer
{
    if (self.target) {
        if (self.block)
            self.block(timer);
        else
            [self.target performSelector:self.selector withObject:timer afterDelay:0.f];
    }
    else
    {
        [self.timer invalidate];
        self.block = nil;
    }
}

- (void)dealloc
{
    NSLog(@"定时器被释放了");
}

@end


@implementation XYWeakTimer

+ (NSTimer *)initWithXYWeakTimer:(NSTimer *)timer
                            interval:(NSTimeInterval)interval
                            target:(id)target
                            selector:(SEL)selector
                            timerBlock:(TimerBlock)timerBlock
                            userInfo:(id)userInfo repeats:(BOOL)repeats
{
    [timer invalidate];
    XYProxy *proxy = [XYProxy alloc];
    proxy.target = target;
    proxy.selector = selector;
    proxy.block = timerBlock;
    proxy.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:proxy selector:@selector(responseTimer:) userInfo:userInfo repeats:repeats];
    
    return proxy.timer;
}

+ (NSTimer *)scheduledTimerWithTime:(NSTimer *)timer
                            interval:(NSTimeInterval)interval
                            target:(id)target
                            selector:(SEL)selector
                            userInfo:(id)userInfo
                            repeats:(BOOL)repeats
{
    return [self initWithXYWeakTimer:timer interval:interval target:target selector:selector timerBlock:nil userInfo:userInfo repeats:repeats];
}

+ (NSTimer *)scheduledTimerWithTime:(NSTimer *)timer
                            interval:(NSTimeInterval)interval
                            target:(id)target
                            timerBlock:(TimerBlock)timerBlock
                            userInfo:(id)userInfo
                            repeats:(BOOL)repeats
{
    return [self initWithXYWeakTimer:timer interval:interval target:target selector:nil timerBlock:timerBlock userInfo:userInfo repeats:repeats];
}

@end
