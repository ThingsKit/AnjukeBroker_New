//
//  HUDNews.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-15.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, HUDTIPSTYPE) {
    HUDTIPSWITHNORMALOK = 0,
    HUDTIPSWITHNORMALBAD,
    HUDTIPSWITHCHECKOK,
    HUDTIPSWITHNetWorkBad
};

@interface HUDNews : NSObject
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) UIImageView *HUDBackGroundView;
@property(nonatomic, strong) UIImageView *statusView;
@property(nonatomic, strong) UILabel *hudLabOne;
@property(nonatomic, strong) UILabel *hudLabTwo;
@property(nonatomic, assign) HUDTIPSTYPE tipsType;
+ (HUDNews *) sharedHUDNEWS;

//创建HUD试图
- (void)createHUD:(NSString *)hudTitleOne hudTitleTwo:(NSString *)hudTitleTwo addView:(UIView *)addView isDim:(BOOL)isDim isHidden:(BOOL)isHidden hudTipsType:(HUDTIPSTYPE)hudTipsType;

@end
