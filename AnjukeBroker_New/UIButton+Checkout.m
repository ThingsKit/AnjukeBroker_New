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

+ (UIButton *)buttonWithCountdown:(NSTimeInterval *)timeInterval{
    return nil;
}

@end
