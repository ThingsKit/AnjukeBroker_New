//
//  AJK_TabBarViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-18.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController <UITabBarControllerDelegate>

@property (nonatomic, strong) UIViewController *page1;
@property (nonatomic, strong) UIViewController *page2;
@property (nonatomic, strong) UIViewController *page3;
@property (nonatomic, strong) UIViewController *page4;

@end
