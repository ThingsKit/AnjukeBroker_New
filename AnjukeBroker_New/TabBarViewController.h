//
//  AJK_TabBarViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-18.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;
@interface TabBarViewController : UITabBarController <UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *controllerArrays;
@property (nonatomic, strong) HomeViewController *HomeVC;

- (void)setMessageBadgeValueWithValue:(NSString *)value; //设置微聊消息数量

@end
