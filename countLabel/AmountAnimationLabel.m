//
//  AmountAnimationLabel.m
//  AmountAnimationLabel
//
//  Created by jhtxch on 16/1/12.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#define Xtime runningTimes * [self onePercentOfTheTime] * 1.000000000

#import "AmountAnimationLabel.h"


@interface AmountAnimationLabel ()
{
    dispatch_source_t _timer;  //定时器
    CGFloat _currentNum;     //显示在界面上的数值
    void(^myCompletionB)(void); //结束后回调的block
    BOOL _isCompletion;     //是否完成
    BOOL _inCompletioning;
    CGFloat _lastNum;
    
}

@end
@implementation AmountAnimationLabel
#pragma mark - instancetype
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _timingFunction = TimingFunctionDefault;
        _timingMode = TimingOnePercentMode;
        _isCompletion = NO;
        _inCompletioning = NO;
        _currentNum = 0;
        self.text = [NSString stringWithFormat:@"0"];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self= [super initWithCoder:aDecoder]) {
        _timingFunction = TimingFunctionDefault;
        _timingMode = TimingOnePercentMode;
        _isCompletion = NO;
        _inCompletioning = NO;
        _currentNum = 0;
        self.text = [NSString stringWithFormat:@"0"];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}



#pragma mark - start
- (void)start
{
    [self startWithCompletionBlock:nil];
}

- (void)startWithCompletionBlock:(void (^)(void))completionBlock
{
    [self createTimer];
    myCompletionB = completionBlock;
}

#pragma mark - timer
- (void)createTimer
{
    __block NSInteger runningTimes = 0; //定时器运行的次数
    _isCompletion = NO;
    _inCompletioning = NO;
    _currentNum = 0;
    if (!_timer) {
        //创建定时器
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        //延迟多久执行
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);
        //设置定时器
        dispatch_source_set_timer(_timer, start, [self onePercentOfTheTime] * NSEC_PER_SEC, 0);
        //定时器回调
        dispatch_source_set_event_handler(_timer, ^{
            NSLog(@"%.2lf",Xtime);
            runningTimes ++;
            if (_timingFunction == TimingFunctionDefault) {
                //匀速
                _currentNum = Xtime * _num / _allTime;
            }
            
            else if (_timingFunction == TimingFunctionEaseIn)
            {
                //
                _currentNum = (_num / pow(_allTime, 2)) * pow(Xtime, 2);
            }
            else if (_timingFunction == TimingFunctionEaseOut)//?
            {
                //
                _currentNum = -(_num / pow(_allTime, 2)) * pow(Xtime, 2) + ((2 * _num)/ _allTime) *Xtime;
            }
            else if (_timingFunction == TimingFunctionEaseInEaseOut)
            {
                _currentNum = ((_num) / 2) * (-cos((M_PI / _allTime) * Xtime) +1) + .01;
            }
            else if (_timingFunction == TimingFunctionFastInFastOut)
                
            {
                _currentNum = (4 * _num / pow(_allTime, 3)) * pow((Xtime - (_allTime / 2)), 3) + _num / 2 + .2*Xtime;
            }
            if (_currentNum > self.num) {
                _currentNum = self.num;
                [self removeTimer];
            }
            if (Xtime >= self.allTime) {
                _currentNum = self.num;
                [self removeTimer];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_isCompletion) {
                    _inCompletioning = YES;
                    _isCompletion = NO;
                    if (myCompletionB) {
                        myCompletionB();
                    }
                }
                [self timerAction];
            });
        });
        dispatch_resume(_timer);
    }
}
//移除定时器
- (void)removeTimer
{
    _isCompletion = YES;
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
- (void)timerAction
{
    if (!_inCompletioning) {
        self.text = [NSString stringWithFormat:@"%.2lf",_currentNum];
    }
    else
    {
        if (fmod(self.num, 1) == 0) {
            self.text = [NSString stringWithFormat:@"%.0lf",_currentNum];
        }
        else if (fmod(self.num * 10, 1) == 0)
        {
            self.text = [NSString stringWithFormat:@"%.1lf",_currentNum];
        }
        else
        {
            
            self.text = [NSString stringWithFormat:@"%.2lf",_currentNum];
        }
    }
    if (_timer) {
    }
}

#pragma mark - otherMethod
//每次所需的时间
- (CGFloat)onePercentOfTheTime
{
    CGFloat count = 100;
    if (self.timingMode == TimingOnePercentMode) {
        count = 100;
    }
    else if (self.timingMode == TimingOneMode)
    {
        count = 1;
    }
    else if (self.timingMode == TimingTenMode)
    {
        count = .1;
    }
    else if (self.timingMode == TimingHundredMode)
    {
        count = .01;
    }
    CGFloat time = (CGFloat)self.allTime / (self.num * count);
    return time;
}


@end
