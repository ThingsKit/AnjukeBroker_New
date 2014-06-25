//
//  UIViewController+Loading.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-8.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "UIViewController+Loading.h"
#import "AppManager.h"

@implementation UIViewController (Loading)

- (void)hideLoadWithAnimated:(BOOL)animated{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)showLoadingActivity:(BOOL)activity{
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([AppManager isiPhone4Display]) {
        hud.yOffset = -45;
    }
    else
        hud.yOffset = -20;
    hud.labelText = @"加载中...";
}

- (void)showInfo:(NSString *)info{
    
    UIWindow *win = [[UIApplication sharedApplication].windows lastObject];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:win animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = info;
    if ([AppManager isiPhone4Display]) {
        hud.yOffset = -85;
    }
    else
        hud.yOffset = -40;
    
    [win addSubview:hud];
    [hud hide:YES afterDelay:2];
}

@end
