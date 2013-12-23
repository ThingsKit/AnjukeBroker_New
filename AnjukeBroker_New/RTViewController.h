//
//  AJK_RTViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-16.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTRequestProxy.h"
#import "UIViewController+Loading.h"
#import "LogKey.h"
#import "BrokerLogger.H"
#import "Util_TEXT.h"
#import "LoginManager.h"

#define STATUS_BAR_H 20
#define NAV_BAT_H 44
#define TAB_BAR_H 44 //系统部分Bar高度

#define FRAME_BETWEEN_NAV_TAB CGRectMake(0, 0, [self windowWidth], [self windowHeight]- STATUS_BAR_H - TAB_BAR_H - NAV_BAT_H)
#define FRAME_WITH_NAV CGRectMake(0, 0, [self windowWidth], [self windowHeight] -STATUS_BAR_H - NAV_BAT_H)

#define ITEM_BTN_FRAME CGRectMake(0, 0, 55, 31)
#define NONETWORK_STR @"网络不给力"
#define ACTIONOK_STR @"操作成功"

typedef enum {
    RTSelectorBackTypePopBack = 0,
    RTSelectorBackTypeDismiss,
    RTSelectorBackTypePopToRoot
} RTSelectorBackType;

@interface RTViewController : UIViewController

@property (nonatomic, assign) RTSelectorBackType backType;
@property BOOL isHome;//判断是否是首页 是首页没有返回键
@property (nonatomic, assign) id delegateVC;

@property BOOL isLoading; //网络请求锁，请求网络时锁住action sheet等动画线程操作

- (void)setTitleViewWithString:(NSString *)titleStr;
- (void)initModel;
- (void)initDisplay;

- (NSInteger)windowHeight; //UIWindow高度，宏_Frame使用，精确控制公用Frame
- (NSInteger)windowWidth;
- (NSInteger)currentViewHeight;  //******当前UIViewController.view的高度，各继承页面UI组件使用

-(void)sendAppearLog;
-(void)sendDisAppearLog;

- (void)doBack:(id)sender;
- (void)addRightButton:(NSString *)title andPossibleTitle:(NSString *)possibleTitle;
- (void)rightButtonAction:(id)sender;
- (void)showTopAlertWithTitle:(NSString *)title; //顶部提示条效果

- (BOOL)isNetworkOkay; //***检查网络是否通畅
@end
