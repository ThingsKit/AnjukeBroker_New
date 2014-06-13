//
//  AXPublicSubMenu.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AXPublicSubMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "BrokerLineView.h"

CGFloat const axPublicSubMenuHeight = 45.0f;

@implementation AXPublicSubMenu
@synthesize publicSubMenuDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)configPublicSubMenu:(AXPublicMenuButton *)button menu:(NSArray *)menus{
    CGRect btnFrame = button.frame;
    
    NSInteger menuCount = menus.count;
    
    CGRect rect = CGRectMake(button.center.x, btnFrame.origin.y - 45*menuCount - 20, 100, 45*menuCount);
    self.frame = rect;

    CGPoint buttonPoint = CGPointMake(button.center.x, button.center.y - 45*menuCount/2);
    self.center = buttonPoint;
    
    UIImageView *cornerView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 4, self.frame.size.height - 1, 8, 5)];
    [cornerView setImage:[UIImage imageNamed:@"wl_map_icon_4"]];
    [self addSubview:cornerView];
    
    //最后一项子菜单,定位调整
    if (button.center.x + button.frame.size.width >= ScreenWidth) {
        CGPoint buttonPoint = CGPointMake(ScreenWidth - 58, button.center.y - 45*menuCount/2);
        self.center = buttonPoint;
        CGRect frame = cornerView.frame;
        frame.origin.x = self.frame.size.width - 35;
        cornerView.frame = frame;
    }
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor brokerLineColor].CGColor;
    
    for (int i = 0; i < menuCount; i++) {
        AXPublicMenuButton *btn = [AXPublicMenuButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(subMenuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, i*axPublicSubMenuHeight, 100, axPublicSubMenuHeight);
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor brokerBgPageColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor brokerBgSelectColor  ]] forState:UIControlStateHighlighted];
        [btn setTitle:[menus objectAtIndex:i][@"menu_title"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:btn];
        
        if (i != menuCount - 1) {
            BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(8, (i+1)*axPublicSubMenuHeight, 84, 1)];
            [self addSubview:line];
        }
    }
    
    [self showSelf];
}

- (void)subMenuBtnClick:(id)sender{
    [self hideSelf];
    AXPublicMenuButton *btn = (AXPublicMenuButton *)sender;
    
    if (!btn.btnInfo[@"menu_type"]) {
        return;
    }
    //api查询
    if ([btn.btnInfo[@"menu_type"] integerValue] == AXPublicSubMenuTypeAPI) {
        if (self.publicSubMenuDelegate && [self.publicSubMenuDelegate respondsToSelector:@selector(publicSubMenuWithAPI:)]) {
            [self.publicSubMenuDelegate publicSubMenuWithAPI:btn.btnInfo[@"action_id"]];
        }
    }
    //打开webView
    if ([btn.btnInfo[@"menu_type"] integerValue] == AXPublicSubMenuTypeWebView) {
        if (self.publicSubMenuDelegate && [self.publicSubMenuDelegate respondsToSelector:@selector(publicSubMenuWithURL:)]) {
            [self.publicSubMenuDelegate publicSubMenuWithURL:btn.btnInfo[@"webview_url"]];
        }
    }
    return;
}

#pragma mark --显示和隐藏自身
- (void)showSelf{
    CGRect frame = self.frame;
    CGRect endFrame = frame;
    endFrame.origin.y = endFrame.origin.y - endFrame.size.height - 30;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = endFrame;
    } completion:^(BOOL finished) {
        nil;
    }];
}

- (void)hideSelf{
    CGRect frame = self.frame;
    CGRect endFrame = frame;
    endFrame.origin.y = endFrame.origin.y + endFrame.size.height + 30;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = endFrame;
    } completion:^(BOOL finished) {
        nil;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
