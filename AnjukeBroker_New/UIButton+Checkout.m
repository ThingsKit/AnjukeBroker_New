//
//  UIButton+Checkout.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "UIButton+Checkout.h"

@implementation UIButton (Checkout)

+ (UIButton *)buttonWithNormalStatus{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"立即签到" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    return btn;
}

+ (UIButton *)buttonWithUnCheck{
    return nil;
}

- (UIButton *)buttonWithCountdown:(double)timeLeft{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
    [icon setImage:[UIImage imageNamed:@"agent_icon43"]];
    [btn addSubview:icon];
    
    self.timeCountLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 150, 30)];
    self.timeCountLab.textAlignment = NSTextAlignmentLeft;
    self.timeCountLab.font = [UIFont systemFontOfSize:14];
    self.timeCountLab.text = [NSString stringWithFormat:@"距下次签到%@",[self changeTimeToStr:timeLeft]];
    [btn addSubview:self.timeCountLab];
    
    return btn;
}

- (NSString *)changeTimeToStr:(double)time{
    NSString *h;
    NSString *m;
    NSString *s;
    
    h = [NSString stringWithFormat:@"%f",time/3600];
    m = [NSString stringWithFormat:@"%f",(time - [h intValue]*3600)/60];
    s = [NSString stringWithFormat:@"%f",time - [h intValue]*3600 - [m intValue]*60];
    
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@:%@",h,m,s];
    
    return timeStr;
}

@end
