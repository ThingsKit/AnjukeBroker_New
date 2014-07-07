//
//  HudTipsUtils.m
//  AnjukeBroker_New
//
//  Created by jason on 7/5/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "HudTipsUtils.h"

@interface HudTipsUtils ()

//浮层相关
@property (nonatomic, strong) MBProgressHUD* hud;
@property (nonatomic, strong) UIImageView* hudBackground;
@property (nonatomic, strong) UIImageView* hudImageView;
@property (nonatomic, strong) UILabel* hudText;

//无网络UI
@property (nonatomic, strong) UIView* emptyBackgroundView;
@property (nonatomic, strong) UIImageView* emptyBackgroundImageView;
@property (nonatomic, strong) UILabel* emptyBackgroundLabel;

@end

@implementation HudTipsUtils


- (void)displayHUDWithStatus:(NSString *)status Message:(NSString*)message ErrCode:(NSString*)errCode toView:(UIView *)view {
  
    if (self.hudBackground == nil) {
        self.hudBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135, 135)];
        self.hudBackground.image = [UIImage imageNamed:@"anjuke_icon_tips_bg"];
        
        self.hudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(135/2-70/2, 135/2-70/2 - 20, 70, 70)];
        self.hudText = [[UILabel alloc] initWithFrame:CGRectMake(10, self.hudImageView.bottom - 5, 115, 60)];
        [self.hudText setTextColor:[UIColor colorWithWhite:0.95 alpha:1]];
        [self.hudText setFont:[UIFont systemFontOfSize:13.0f]];
        self.hudText.numberOfLines = 0;
        [self.hudText setTextAlignment:NSTextAlignmentCenter];
        self.hudText.backgroundColor = [UIColor clearColor];
        
        [self.hudBackground addSubview:self.hudImageView];
        [self.hudBackground addSubview:self.hudText];
        
    }
    
    //使用 MBProgressHUD
    self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.hud.color = [UIColor clearColor];
    self.hud.customView = self.hudBackground;
    self.hud.yOffset = -20;
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.dimBackground = NO;
    
    if ([@"ok" isEqualToString:status]) { //成功的状态提示
        self.hudImageView.image = [UIImage imageNamed:@"check_status_ok"];
        self.hudText.text = message;
    }else{ //失败的状态提示
        if ([@"1" isEqualToString:errCode]) {
            self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_sad"];
            self.hudText.text = message;
            
        }else{
            self.hudImageView.image = [UIImage imageNamed:@"check_no_wifi"];
            self.hudImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.hudText.text = @"无网络连接";
            self.hudText.hidden = NO;
            
        }
    }
    [view bringSubviewToFront:self.hud];
    [self.hud show:YES];
    
    [self.hud hide:YES afterDelay:2]; //显示一段时间后隐藏
}

+ (id)sharedInstance
{
    static HudTipsUtils *hudTips ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hudTips = [HudTipsUtils new];
    });
    return hudTips;
}

@end
