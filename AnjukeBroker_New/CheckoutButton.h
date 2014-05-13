//
//  CheckoutButton.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutButton : UIButton
@property(nonatomic, strong) UILabel *timeCountLab;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) int leftTime;
+ (UIButton *)buttonWithNormalStatus;
+ (UIButton *)buttonWithUnCheck;
- (UIButton *)buttonWithCountdown:(int)timeLeft;

@end
