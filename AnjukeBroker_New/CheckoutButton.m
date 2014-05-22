//
//  CheckoutButton.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CheckoutButton.h"
#import "UIFont+RT.h"
#import <QuartzCore/QuartzCore.h>

@implementation CheckoutButton
@synthesize checkoutDelegate;
@synthesize timer;
@synthesize leftTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#pragma mark - 签到按钮-常规
- (UIButton *)buttonWithNormalStatus{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor brokerBabyBlueColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor brokerBlueColor]] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont ajkH1Font_B];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 2.5;
    [btn setTitle:@"立即签到" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    return btn;
}
#pragma mark - 签到按钮-签到中
- (UIButton *)buttonWithChecking{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor ajkLightGrayColor];
    btn.titleLabel.font = [UIFont ajkH1Font_B];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 2.5;
    [btn setTitle:@"签到中..." forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    
    return btn;
}
#pragma mark - 签到按钮-加载中
- (UIButton *)buttonWithLoading{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor ajkLightGrayColor];
    btn.titleLabel.font = [UIFont ajkH1Font_B];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 2.5;
    [btn setTitle:@"加载中..." forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
  
    return btn;
}
#pragma mark - 签到按钮倒计时
- (UIButton *)buttonWithCountdown:(int)timeLeft{
    leftTime = timeLeft;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor ajkLightGrayColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 2.5;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 7, 18, 25)];
    [icon setImage:[UIImage imageNamed:@"countTime_icon"]];
    [btn addSubview:icon];
    
    if (self.timeCountLab) {
        [self.timeCountLab removeFromSuperview];
        self.timeCountLab = nil;
    }
    self.timeCountLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 185, 20)];
    self.timeCountLab.textAlignment = NSTextAlignmentLeft;
    self.timeCountLab.font = [UIFont ajkH2Font_B];
    self.timeCountLab.textColor = [UIColor ajkWhiteColor];
    self.timeCountLab.backgroundColor = [UIColor clearColor];
    self.timeCountLab.text = [NSString stringWithFormat:@"距下次签到:  %@",[self changeTimeToStr:timeLeft]];
    [btn addSubview:self.timeCountLab];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(downTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

    return btn;
}
//时间转换
- (NSString *)changeTimeToStr:(int)time{
    NSString *h;
    NSString *m;
    NSString *s;
    
    int hNum;
    int mNum;
    int sNum;
    
    hNum = time/3600;
    mNum = (time - hNum*3600)/60;
    sNum = time - hNum*3600 - mNum*60;

    if (hNum == 0) {
        h = @"00";
    }else if (hNum < 10){
        h = [NSString stringWithFormat:@"0%d",hNum];
    }else{
        h = [NSString stringWithFormat:@"%d",hNum];
    }

    if (mNum == 0) {
        m = @"00";
    }else if (mNum < 10){
        m = [NSString stringWithFormat:@"0%d",mNum];
    }else{
        m = [NSString stringWithFormat:@"%d",mNum];
    }
    
    if (sNum == 0) {
        s = @"00";
    }else if (sNum < 10){
        s = [NSString stringWithFormat:@"0%d",sNum];
    }else{
        s = [NSString stringWithFormat:@"%d",sNum];
    }
    
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@:%@",h,m,s];
    
    return timeStr;
}

- (void)downTime{
    leftTime = leftTime - 1;
    if (leftTime <= 1) {
        [checkoutDelegate timeCountZero];
        [self.timer invalidate];
    }else{
        NSString *str = [self changeTimeToStr:leftTime];

        self.timeCountLab.text = [NSString stringWithFormat:@"距下次签到:  %@",str];
    }
}
@end
