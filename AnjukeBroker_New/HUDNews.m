//
//  HUDNews.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-15.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "HUDNews.h"


@implementation HUDNews
@synthesize hud;
@synthesize HUDBackGroundView;
@synthesize statusView;
@synthesize hudLabOne;
@synthesize hudLabTwo;
@synthesize tipsType;

static HUDNews *hudNews;

//hud 才用单例实现
+ (HUDNews *) sharedHUDNEWS{
    @synchronized(self){
        if (hudNews == nil) {
            hudNews = [[HUDNews alloc] init];
        }
        return hudNews;
    }
}
#pragma mark - 外部调用创建hud method
- (void)createHUD:(NSString *)hudTitleOne hudTitleTwo:(NSString *)hudTitleTwo addView:(UIView *)addView isDim:(BOOL)isDim isHidden:(BOOL)isHidden hudTipsType:(HUDTIPSTYPE)hudTipsType{
    tipsType = hudTipsType;
    if (self.hud) {
        [self.hud hide:YES];
//        [self.HUDBackGroundView removeFromSuperview];
    }
    self.HUDBackGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135, 135)];
    [self.HUDBackGroundView setImage:[UIImage imageNamed:@"anjuke_icon_tips_bg"]];
    
    
    self.statusView = [[UIImageView alloc] initWithFrame:CGRectMake(32, 10, 70, 70)];
    if (hudTipsType == HUDTIPSWITHNORMALOK) {
        [self.statusView setImage:[UIImage imageNamed:@"anjuke_icon_tips_laugh"]];
    }else if(hudTipsType == HUDTIPSWITHNORMALBAD){
        [self.statusView setImage:[UIImage imageNamed:@"anjuke_icon_tips_sad"]];
    }else if(hudTipsType == HUDTIPSWITHCHECKOK){
        [self.statusView setImage:[UIImage imageNamed:@"check_status_ok"]];
    }
    [self.HUDBackGroundView addSubview:self.statusView];
    
    if (hudTitleOne && hudTitleTwo) {
        self.hudLabOne = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 135, 25)];
        self.hudLabOne.backgroundColor = [UIColor clearColor];
        self.hudLabOne.textColor = [UIColor whiteColor];
        self.hudLabOne.text = hudTitleOne;
        self.hudLabOne.textAlignment = NSTextAlignmentCenter;
        self.hudLabOne.font = [UIFont systemFontOfSize:18];
        [self.HUDBackGroundView addSubview:self.hudLabOne];
        
        self.hudLabTwo = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, 135, 20)];
        self.hudLabTwo.backgroundColor = [UIColor clearColor];
        self.hudLabTwo.textColor = [UIColor whiteColor];
        self.hudLabTwo.text = hudTitleTwo;
        self.hudLabTwo.textAlignment = NSTextAlignmentCenter;
        self.hudLabTwo.font = [UIFont systemFontOfSize:14];
        [self.HUDBackGroundView addSubview:self.hudLabTwo];
    }else{
        self.statusView.frame = CGRectMake(32, 20, 70, 70);
        self.hudLabOne = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, 135, 20)];
        self.hudLabOne.backgroundColor = [UIColor clearColor];
        self.hudLabOne.textColor = [UIColor whiteColor];
        self.hudLabOne.text = hudTitleOne;
        self.hudLabOne.textAlignment = NSTextAlignmentCenter;
        self.hudLabOne.font = [UIFont systemFontOfSize:14];
        [self.HUDBackGroundView addSubview:self.hudLabOne];
    }
    
    [self showHUD:self.HUDBackGroundView addView:addView isDim:isDim isHidden:isHidden];
}

- (void)showHUD:(UIImageView *)backView addView:(UIView *)addView isDim:(BOOL)isDim isHidden:(BOOL)isHidden{
    [self showHUDWithView:backView addView:addView isDim:isDim isHidden:isHidden];
    if (isHidden) {
        if (tipsType == HUDTIPSWITHCHECKOK) {
            [self.hud hide:YES afterDelay:2.0];
        }else{
            [self.hud hide:YES afterDelay:1.0];
        }
    }
}

//使用 MBProgressHUD
- (void)showHUDWithView:(UIImageView *)backView addView:(UIView *)addView isDim:(BOOL)isDim isHidden:(BOOL)isHidden {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.hud = [MBProgressHUD showHUDAddedTo:addView animated:YES];
    self.hud.color = [UIColor clearColor];
    self.hud.customView = backView;
    self.hud.yOffset = -20;
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.dimBackground = isDim;
}

@end
