//
//  AJK_RTViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-16.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STATUS_BAR_H 20
#define NAV_BAT_H 44
#define TAB_BAR_H 44 //系统部分Bar高度

#define FRAME_BETWEEN_NAV_TAB CGRectMake(0, 0, [self windowWidth], [self windowHeight]- STATUS_BAR_H - TAB_BAR_H - NAV_BAT_H)
#define FRAME_WITH_NAV CGRectMake(0, 0, [self windowWidth], [self windowHeight] -STATUS_BAR_H - NAV_BAT_H)

#define ITEM_BTN_FRAME CGRectMake(0, 0, 55, 31)

typedef enum {
    RTSelectorBackTypePopBack = 0,
    RTSelectorBackTypeDismiss,
    RTSelectorBackTypePopToRoot
} RTSelectorBackType;

@interface RTViewController : UIViewController

@property (nonatomic, assign) RTSelectorBackType backType;
@property BOOL isHome;//判断是否是首页 是首页没有返回键

- (void)setTitleViewWithString:(NSString *)titleStr;
- (void)initModel;
- (void)initDisplay;

- (NSInteger)windowHeight; //UIWindow高度，宏_Frame使用，精确控制公用Frame
- (NSInteger)windowWidth;
- (NSInteger)currentViewHeight;  //******当前UIViewController.view的高度，各继承页面UI组件使用

- (void)addBackButton;
- (void)doBack:(id)sender;

@end
