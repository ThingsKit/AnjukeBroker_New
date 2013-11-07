//
//  UIViewController+Loading.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-8.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (Loading)

- (void)hideLoadWithAnimated:(BOOL)animated;
- (void)showLoadingActivity:(BOOL)activity;
- (void)showInfo:(NSString *)info;

@end
