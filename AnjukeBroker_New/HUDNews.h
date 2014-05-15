//
//  HUDNews.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-15.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HUDNews : NSObject
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) UIImageView *HUDBackGroundView;
@property(nonatomic, strong) UIImageView *statusView;
@property(nonatomic, strong) UILabel *hudLabOne;
@property(nonatomic, strong) UILabel *hudLabTwo;
+ (HUDNews *) sharedHUDNEWS;

//创建HUD试图
- (void)createHUD:(NSString *)hudTitleOne hudTitleTwo:(NSString *)hudTitleTwo addView:(UIView *)addView isDim:(BOOL)isDim isHidden:(BOOL)isHidden statusOK:(BOOL)statusOK;

@end
