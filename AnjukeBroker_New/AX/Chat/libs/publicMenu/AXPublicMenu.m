//
//  AXPublicMenu.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AXPublicMenu.h"
#import "BrokerLineView.h"

CGFloat const axPublicMenuHeight = 49.0f;

@implementation AXPublicMenu
@synthesize publicMenuDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHex:0Xf6f6f6 alpha:1.0];
    }
    return self;
}

- (void)configPublicMenuView:(NSArray *)menus inputType:(AXPublicInputType)inputType{
    if (inputType == AXPublicInputTypeNormal) {
        return;
    }
    float menuWidth;
    float leftX = 0;
//    NSInteger menuCount = menus.count;
    NSInteger menuCount = 3;
    if (menuCount < 1) {
        return;
    }
    if (inputType == AXPublicInputTypePublicMenu){
        menuWidth = ScreenWidth/menuCount;
        leftX = 0;
    }else if (inputType == AXPublicInputTypeNormalAndPublicMenu){
        UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        switchBtn.frame = CGRectMake(48/2-16, axPublicMenuHeight/2 - 16, 32, 32);
        [switchBtn setImage:[UIImage imageNamed:@"broker_wl_gzh_a"] forState:UIControlStateNormal];
        [switchBtn setImage:[UIImage imageNamed:@"broker_wl_gzh_a_press"] forState:UIControlStateHighlighted];
        [switchBtn addTarget:self action:@selector(publicMenuSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:switchBtn];
        
        menuWidth = (ScreenWidth - 48)/menuCount;
        leftX = 48;
    }
    
//    for (int i = 0; i < MIN(3, menuCount); i++) {
    for (int i = 0; i < 3; i++) {
        AXPublicMenuButton *btn = [AXPublicMenuButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftX + menuWidth*i, 0, menuWidth, axPublicMenuHeight);
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0Xf6f6f6 alpha:1.0]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor brokerBgSelectColor]] forState:UIControlStateHighlighted];
        btn.btnInfo = [menus objectAtIndex:i];
        btn.index = i;
        [btn setTitle:[menus objectAtIndex:i][@"menu_title"] forState:UIControlStateNormal];
        [btn setTitle:[NSString stringWithFormat:@"菜单%d",i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
//        btn.titleLabel.textColor = [UIColor brokerBlackColor];
        [btn setTitleColor:[UIColor brokerBlackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor brokerBlackColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(publicMenuClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        if (inputType == AXPublicInputTypePublicMenu && i == 0) {
            return;
        }else{
            BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(leftX + menuWidth*i, 0, 1, axPublicMenuHeight)];
            line.horizontalLine = NO;
            [self addSubview:line];
        }
    }
}
#pragma mark -- publicMenuClick
- (void)publicMenuClick:(id)sender{
    AXPublicMenuButton *btn = (AXPublicMenuButton *)sender;

    if (btn.index == 0) {
        if (self.publicMenuDelegate && [self.publicMenuDelegate respondsToSelector:@selector(publicMenuWithAPI:)]) {
            [self.publicMenuDelegate publicMenuWithAPI:btn.btnInfo[@"action_id"]];
        }
    }else if (btn.index == 1){
        if (self.publicMenuDelegate && [self.publicMenuDelegate respondsToSelector:@selector(publicMenuWithURL:)]) {
            [self.publicMenuDelegate publicMenuWithURL:btn.btnInfo[@"webview_url"]];
        }
    }else if (btn.index == 2){
        if (self.publicMenuDelegate && [self.publicMenuDelegate respondsToSelector:@selector(publicMenuShowSubMenu:menus:)]) {
            [self.publicMenuDelegate publicMenuShowSubMenu:btn menus:[NSArray arrayWithArray:btn.btnInfo[@"sub_menu_list"]]];
        }
    }
    
    if (!btn.btnInfo[@"menu_type"]) {
        return;
    }
    //api查询
    if ([btn.btnInfo[@"menu_type"] integerValue] == AXPublicMenuTypeAPI) {
        if (self.publicMenuDelegate && [self.publicMenuDelegate respondsToSelector:@selector(publicMenuWithAPI:)]) {
            [self.publicMenuDelegate publicMenuWithAPI:btn.btnInfo[@"action_id"]];
        }
    }
    //打开webView
    if ([btn.btnInfo[@"menu_type"] integerValue] == AXPublicMenuTypeWebView) {
        if (self.publicMenuDelegate && [self.publicMenuDelegate respondsToSelector:@selector(publicMenuWithURL:)]) {
            [self.publicMenuDelegate publicMenuWithURL:btn.btnInfo[@"webview_url"]];
        }
    }
    //打开子菜单
    if ([btn.btnInfo[@"menu_type"] integerValue] == AXPublicMenuTypeSubMenu) {
        if (self.publicMenuDelegate && [self.publicMenuDelegate respondsToSelector:@selector(publicMenuShowSubMenu:menus:)]) {
            [self.publicMenuDelegate publicMenuShowSubMenu:btn menus:[NSArray arrayWithArray:btn.btnInfo[@"sub_menu_list"]]];
        }
    }
}

#pragma mark -- publicMenuSwitch
- (void)publicMenuSwitch:(id)sender{
    [self.publicMenuDelegate publicMenuSwich];
}

@end
