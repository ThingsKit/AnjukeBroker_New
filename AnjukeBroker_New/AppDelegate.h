//
//  AppDelegate.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-15.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"
#import "LoginViewController.h"
#import "AFWelcomeScrollview.h"
#import "VersionUpdateManager.h"
#import "UpdateUserLocation.h"

typedef enum {
    SwitchType_RentNoPlan = 0, //租房未推广
    SwitchType_RentFixed, //定价
    SwitchType_RentBid, //竞价
    SwitchType_SaleNoPlan, //二手房未推广
    SwitchType_SaleFixed,
    SwitchType_SaleBid
} TabSwitchType; //发房结束后tab0跳tab1、2的结果PPC管理请求类型

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, AFWelcomeScrollViewDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) LoginViewController *loginVC;
@property (nonatomic, strong) TabBarViewController *tabController;

@property (nonatomic, assign) TabSwitchType tabSwitchType;
@property BOOL isEnforceUpdate; //是否强制更新
@property BOOL boolNeedAlert; //没有更新是否需要弹框提示（YES为检查更新用）
@property (nonatomic, copy) NSString *updateUrl; //升级url
@property (nonatomic, strong) VersionUpdateManager *versionUpdate;

//push notification
@property (nonatomic, assign) NSInteger propertyPushCount; //未读房源推送总数
@property (nonatomic, assign) NSInteger unReadPushCount; //未读消息总数(包括房源和微聊)
@property (nonatomic, assign) BOOL appDidBecomeActive; //应用第一次进入首页
@property (nonatomic, assign) int old;

//- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//private method
+ (AppDelegate *)sharedAppDelegate;

- (void)requestSalePropertyConfig;
- (void)doLogOut;
- (void)showMessageValueWithStr:(int)value; //显示消息条数
- (void)showNewMessageCountForTab;

- (void)connectLongLinkForChat;
- (void)killLongLinkForChat;
- (BOOL)checkHomeVCHasLongLinked;

//用于发房结束后页面跳转到计划管理房源列表页面
- (void)dismissController:(UIViewController *)dismissController withSwitchIndex:(int)index withSwtichType:(TabSwitchType)switchType withPropertyDic:(NSDictionary *)propDic;
//- (void)checkVersionForMore:(BOOL)forMore; // 新版本更新检查
@end
