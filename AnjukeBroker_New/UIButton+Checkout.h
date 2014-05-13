//
//  UIButton+Checkout.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Checkout)
@property(nonatomic, strong) UILabel *timeCountLab;

+ (UIButton *)buttonWithNormalStatus;
+ (UIButton *)buttonWithUnCheck;
- (UIButton *)buttonWithCountdown:(double)timeLeft;
@end
