//
//  CheckoutButton.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol checkoutButtonDelegate <NSObject>
- (void)timeCountZero;
@end

@interface CheckoutButton : UIButton
@property(nonatomic, assign) id<checkoutButtonDelegate> checkoutDelegate;
@property(nonatomic, strong) UILabel *timeCountLab;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) NSInteger leftTime;


- (UIButton *)buttonWithNormalStatus;
- (UIButton *)buttonWithChecking;
- (UIButton *)buttonWithLoading;
- (UIButton *)buttonWithCountdown:(int)timeLeft;

@end
