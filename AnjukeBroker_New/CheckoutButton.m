//
//  CheckoutButton.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CheckoutButton.h"

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
- (UIButton *)buttonWithNormalStatus{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor blueColor];
    [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    [btn setTitle:@"立即签到" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    return btn;
}

- (UIButton *)buttonWithUnCheck{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blueColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn setTitle:@"加载中..." forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    
//    UIActivityIndicatorView *activityView= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    activityView.center=CGPointMake(110, 20);
//    [activityView startAnimating];
//    [btn addSubview:activityView];
    
    return btn;
}

- (UIButton *)buttonWithCountdown:(int)timeLeft{
    leftTime = timeLeft;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blueColor];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [icon setImage:[UIImage imageNamed:@"agent_icon43"]];
    [btn addSubview:icon];
    
    self.timeCountLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 150, 20)];
    self.timeCountLab.textAlignment = NSTextAlignmentLeft;
    self.timeCountLab.font = [UIFont systemFontOfSize:14];
    self.timeCountLab.textColor = [UIColor whiteColor];
    self.timeCountLab.text = [NSString stringWithFormat:@"距下次签到:%@",[self changeTimeToStr:timeLeft]];
    [btn addSubview:self.timeCountLab];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(downTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

    return btn;
}

- (NSString *)changeTimeToStr:(int)time{
    NSString *h;
    NSString *m;
    NSString *s;
    
    h = [NSString stringWithFormat:@"%d",time/3600];
    if ((time - [h intValue]*3600)/60 < 10) {
        m = [NSString stringWithFormat:@"0%d",(time - [h intValue]*3600)/60];
    }else{
        m = [NSString stringWithFormat:@"%d",(time - [h intValue]*3600)/60];
    }
    if (time - [h intValue]*3600 - [m intValue]*60 < 10) {
        s = [NSString stringWithFormat:@"0%d",time - [h intValue]*3600 - [m intValue]*60];
    }else{
        s = [NSString stringWithFormat:@"%d",time - [h intValue]*3600 - [m intValue]*60];
    }
    
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@:%@",h,m,s];
    
    return timeStr;
}

- (void)downTime{
    leftTime = leftTime - 1;
    if (leftTime <= 0) {
        [checkoutDelegate timeCountZero];
        [self.timer invalidate];
    }else{
        NSString *str = [self changeTimeToStr:leftTime];

        self.timeCountLab.text = [NSString stringWithFormat:@"距下次签到:%@",str];
    }
}
@end
