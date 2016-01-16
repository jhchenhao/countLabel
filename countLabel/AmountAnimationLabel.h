//
//  AmountAnimationLabel.h
//  AmountAnimationLabel
//
//  Created by jhtxch on 16/1/12.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import <UIKit/UIKit.h>

//运行方式
typedef enum : NSUInteger {
    TimingFunctionDefault, //线性 默认
    TimingFunctionEaseIn, //先慢后快
    TimingFunctionEaseOut, //先快后慢
    TimingFunctionEaseInEaseOut,//慢入慢出 中间快
    TimingFunctionFastInFastOut //快入快出 中间慢
} TimingFunction;

//每次累加的数值
typedef enum : NSUInteger {
    TimingOnePercentMode, //0.01
    TimingOneMode,    //1
    TimingTenMode,     //10
    TimingHundredMode     //100
} TimingMode;

@interface AmountAnimationLabel : UILabel
//跨度不要太大 如果allTime为1s num 上千会引起误差

@property (nonatomic, assign) NSTimeInterval allTime;
@property (nonatomic, assign) CGFloat num;
@property (nonatomic, assign) TimingFunction timingFunction;
@property (nonatomic, assign) TimingMode timingMode;

- (void)start;
- (void)startWithCompletionBlock:(void(^)(void))completionBlock;


@end
