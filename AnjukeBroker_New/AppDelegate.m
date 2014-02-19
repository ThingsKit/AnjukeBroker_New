//
//  AppDelegate.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-15.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AppDelegate.h"
#import "RTNavigationController.h"
#import "LoginManager.h"
#import "ConfigPlistManager.h"
#import "AccountManager.h"
#import "AppManager.h"
#import "AFWelcomeScrollview.h"
#import "Reachability.h"
#import "AppManager.h"
#import "Util_UI.h"

#import "SaleNoPlanGroupController.h"
#import "RentNoPlanController.h"
#import "SaleBidDetailController.h"
#import "RentBidDetailController.h"
#import "RentFixedDetailController.h"
#import "SaleFixedDetailController.h"

#define coreDataName @"AnjukeBroker_New"
#define code_AppName @"i-broker"

#define UMENG_KEY_OFFLINE @"529da42356240b93f001f9b4"
#define UMENG_KEY_ONLINE @"52a0368c56240ba07800b4c0"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize rootViewController;
@synthesize loginVC;
@synthesize tabController;
@synthesize tabSwitchType;
@synthesize updateUrl;
@synthesize isEnforceUpdate;
@synthesize boolNeedAlert;

+ (AppDelegate *)sharedAppDelegate {
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //初始化底层库
    [self initRTManager];
    
    //add root viewController
    [self checkLogin];
    
    [self.window makeKeyAndVisible];
        
    [self registerRemoteNotification];
    [self cleanRemoteNotification:application];
    
    [self checkVersionForMore:NO];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self cleanRemoteNotification:application];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [CrashLogUtil writeCrashLog];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AnjukeBroker_New" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AnjukeBroker_New.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Register Method

- (void)registerRemoteNotification {
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [deviceToken description];
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"deviceToken"]; //deviceToekn
    
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[AccountManager sharedInstance] setNotificationDeviceToken:token];
    
    DLog(@"device token: %@",token);
    
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送" message:token delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    //    [alertView show];
    //    [alertView release];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    DLog(@"didFailToRegisterForRemoteNotificationsWithError %@", [error description]);
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送" message:[error description] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [alertView show];
}

- (void)cleanRemoteNotification:(UIApplication *)application{
    application.applicationIconBadgeNumber = 1;
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [self cleanRemoteNotification:application];
    
    if (application.applicationState == UIApplicationStateInactive) {
        DLog(@"userInfo [%@]", userInfo);
    }
}

- (void)registerNotificationFinish:(RTNetworkResponse *)response{
    DLog(@"registerNotificationFinish %@", response.content);
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Private Method

- (void)initRTManager {
    //数据库初始化
    [[RTCoreDataManager sharedInstance] setModelName:coreDataName];
    
    //appLog初始化：app name, channelid, umeng key
    [[RTLogger sharedInstance] setLogAppName:code_AppName];
#ifdef DEBUG
    [[RTLogger sharedInstance] setUmengKey:UMENG_KEY_OFFLINE channelID:@"A01"];
#else
    [[RTLogger sharedInstance] setUmengKey:UMENG_KEY_ONLINE channelID:@"A01"];
#endif
    
    //网络请求初始化
    [[RTRequestProxy sharedInstance] setAppName:code_AppName];
    [[RTRequestProxy sharedInstance] setChannelID:@"A01"];
    [[RTRequestProxy sharedInstance] setLogger:[RTLogger sharedInstance]];
    
    //gps定位信息
    [[RTLocationManager sharedInstance] restartLocation];
}

- (void)checkLogin {
    //test add login
    LoginViewController *lb = [[LoginViewController alloc] init];
    self.loginVC = lb;
    RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:lb];
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
    
    if ([AppManager isFirstLaunch]) {
        AFWelcomeScrollview *af = [[AFWelcomeScrollview alloc] initWithFrame:self.window.bounds];
        NSArray *imgBGArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"anjuke_icon_come1_bg.png"],[UIImage imageNamed:@"anjuke_icon_come2_bg.png"], nil];
        NSArray *imgIconArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"anjuke_icon_come1_icon.png"],[UIImage imageNamed:@"anjuke_icon_come2_icon.png"], nil];
        
        [af setImageBGArr:imgBGArr withTitleArray:[NSArray arrayWithObjects:@"语音输入",@"附近小区", nil] withImgIconArr:imgIconArr withDetailArr:[NSArray arrayWithObjects:@"声音书写房源描述",@"发现身边蓝海小区", nil]];
        
        [nav.view addSubview:af];
    }
}

- (void)checkVersionForMore:(BOOL)forMore { // 新版本更新检查
    if (![self checkNetwork]) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"i" ,@"o" , nil];
    
    if (forMore) {
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"checkversion/" params:params target:self action:@selector(onGetVersionForMore:)];
    }
    else {
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"checkversion/" params:params target:self action:@selector(onGetVersion:)];
    }
}

- (void)onGetVersion:(RTNetworkResponse *) response {
    DLog(@"%@", [response content]);
    //check network and response
    if (![self checkNetwork])
        return;
    
    if ([response status] == RTNetworkResponseStatusFailed || ([[[response content] objectForKey:@"status"] isEqualToString:@"error"]))
        return;
    
    NSDictionary *resultFromAPI = [[response content] objectForKey:@"data"];
    
    if ([resultFromAPI count] != 0) {
        self.updateUrl = [NSString stringWithFormat:@"%@",[resultFromAPI objectForKey:@"url"]];
        //        DLog(@"get message update 返回--[%@] url[%@]",[[response content] objectForKey:@"update"], self.updateUrl);
        
        if ([resultFromAPI objectForKey:@"ver"] != nil && ![[resultFromAPI objectForKey:@"ver"] isEqualToString:@""]) {
            NSString *onlineVer = [resultFromAPI objectForKey:@"ver"];
            //强制更新
            if ([[resultFromAPI objectForKey:@"is_enforce"] isEqualToString:@"1"]) {
                self.isEnforceUpdate = YES;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新%@版本",onlineVer]
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"立即更新", @"退出应用", nil];
                av.tag = 101;
                [av show];
                
                return;
            }else{
                self.isEnforceUpdate = NO;
            }
            
            DLog(@"appVer[%f] checkVer[%f]",[onlineVer floatValue], [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue]);
            
            NSString *localVer = [AppManager getBundleVersion];
            
//            if (![UtilText isNumber:[UtilText rmPointFromString:localVer]]) { //有英文表示为测试版
//                if (self.boolNeedAlert) {
//                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:Nil message:@"测试版本" delegate:Nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//                    [av show];
//                    self.boolNeedAlert = NO;
//                }
//                return;
//            }else
                if ([localVer compare:onlineVer options:NSNumericSearch] == NSOrderedAscending) { //有更新
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新%@版本",onlineVer]
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"稍后再说"
                                                   otherButtonTitles:@"立即更新",nil];
                av.cancelButtonIndex = 0;
                    av.tag = 102;
                [av show];
            }else{
                if (self.boolNeedAlert) {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"没有发现新版本" delegate:Nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [av show];
                    self.boolNeedAlert = NO;
                }
            }
        }
    }
}

- (void)onGetVersionForMore:(RTNetworkResponse *) response {
    DLog(@"%@", [response content]);
    //check network and response
    if (![self checkNetwork])
        return;
    
    if ([response status] == RTNetworkResponseStatusFailed || ([[[response content] objectForKey:@"status"] isEqualToString:@"error"]))
        return;
    
    //更多中点击检查更新，此处适配版本更新查不到表的情况，api返回空arr数组，弹框提示无新版本
    id arr = [[response content] objectForKey:@"data"];
    if ([arr isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)arr count] == 0) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"没有发现新版本" delegate:Nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [av show];
            self.boolNeedAlert = NO;
            return;
        }
    }
    
    NSDictionary *resultFromAPI = [[response content] objectForKey:@"data"];
    
    if ([resultFromAPI count] != 0) {
        self.updateUrl = [NSString stringWithFormat:@"%@",[resultFromAPI objectForKey:@"url"]];
        //        DLog(@"get message update 返回--[%@] url[%@]",[[response content] objectForKey:@"update"], self.updateUrl);
        
        if ([resultFromAPI objectForKey:@"ver"] != nil && ![[resultFromAPI objectForKey:@"ver"] isEqualToString:@""]) {
            NSString *onlineVer = [resultFromAPI objectForKey:@"ver"];
            //强制更新
            if ([[resultFromAPI objectForKey:@"is_enforce"] isEqualToString:@"1"]) {
                self.isEnforceUpdate = YES;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新%@版本",onlineVer]
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"立即更新", @"退出应用", nil];
                av.tag = 101;
                [av show];
                
                return;
            }else{
                self.isEnforceUpdate = NO;
            }
            
            DLog(@"appVer[%f] checkVer[%f]",[onlineVer floatValue], [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue]);
            
            NSString *localVer = [AppManager getBundleVersion];
            
            //            if (![UtilText isNumber:[UtilText rmPointFromString:localVer]]) { //有英文表示为测试版
            //                if (self.boolNeedAlert) {
            //                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:Nil message:@"测试版本" delegate:Nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            //                    [av show];
            //                    self.boolNeedAlert = NO;
            //                }
            //                return;
            //            }else
            if ([localVer compare:onlineVer options:NSNumericSearch] == NSOrderedAscending) { //有更新
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新%@版本",onlineVer]
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"稍后再说"
                                                   otherButtonTitles:@"立即更新",nil];
                av.cancelButtonIndex = 0;
                av.tag = 102;
                [av show];
            }else{
                if (self.boolNeedAlert) {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"没有发现新版本" delegate:Nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [av show];
                    self.boolNeedAlert = NO;
                }
            }
        }
    }
}

- (BOOL)checkNetwork {
    // check if network is available
    if (![[RTRequestProxy sharedInstance] isInternetAvailiable]) {
        return NO;
    }
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    if ([r currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    
    return YES;
}
- (void)doLogOut {
    //    [self.window.rootViewController.navigationController popToRootViewControllerAnimated:YES];
    
    [self.loginVC doLogOut];
}

#pragma mark - Request Method

//获取房源配置信息
- (void)requestSalePropertyConfig{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getCity_id], @"cityId", nil];
    
//    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/prop/getconfig/" params:params target:self action:@selector(onGetSaleSuccess:)];
    
    [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/prop/getconfig/" params:params target:self action:@selector(onGetSaleSuccess:)];
}

- (void)onGetSaleSuccess:(RTNetworkResponse *)response {
    DLog(@"---er---response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
//        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alert show];
        
        return;
    }
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    
    //本地固化，处理二手房发房数据
    [ConfigPlistManager savePlistWithDic:resultFromAPI withName:AJK_ALL_PLIST];
    [ConfigPlistManager setAnjukeDataPlistWithDic:resultFromAPI];
    
    [self requestRentPropertyConfig];
}

- (void)requestRentPropertyConfig{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getCity_id], @"cityId", nil];
    
//    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/prop/getconfig/" params:params target:self action:@selector(onGetRentSuccess:)];
    
    [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/prop/getconfig/" params:params target:self action:@selector(onGetRentSuccess:)];
    
}

- (void)onGetRentSuccess:(RTNetworkResponse *)response {
    DLog(@"---hz---response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
//        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alert show];
        
        return;
    }
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    
    //本地固化
    [ConfigPlistManager savePlistWithDic:resultFromAPI withName:HZ_ALL_PLIST];
    [ConfigPlistManager setHaozuDataPlistWithDic:resultFromAPI];
    
}

#pragma mark - Switch Method

- (void)dismissController:(UIViewController *)dismissController withSwitchIndex:(int)index withSwtichType:(TabSwitchType)switchType withPropertyDic:(NSDictionary *)propDic {
    [dismissController dismissViewControllerAnimated:NO completion:^(void){
        [self switchTabControllerWithIndex:index];
        
        [self doHomeNavPushWithSwitchIndex:index withSwtichType:switchType withPropertyDic:propDic];
    }];
}

- (void)switchTabControllerWithIndex:(int)index {
    if (!self.tabController) {
        return;
    }
    
    if (index >= self.tabController.controllerArrays.count) {
        return;
    }
    
    [self.tabController setSelectedIndex:index];
    
}

- (void)doHomeNavPushWithSwitchIndex:(int)index withSwtichType:(TabSwitchType)switchType withPropertyDic:(NSDictionary *)propDic {
    NSString *message = @"发布成功！";
    
    switch (switchType) {
        case SwitchType_RentFixed: //租房定价
        {
            RentFixedDetailController *controller = [[RentFixedDetailController alloc] init];
            controller.tempDic = propDic;
            controller.backType = RTSelectorBackTypePopToRoot;
            [controller setHidesBottomBarWhenPushed:YES];
            [[[self.tabController controllerArrays] objectAtIndex:index] pushViewController:controller animated:YES];
            [controller showTopAlertWithTitle:message];
        }
            break;
        case SwitchType_SaleFixed: //二手房定价
        {
            SaleFixedDetailController *controller = [[SaleFixedDetailController alloc] init];
            controller.tempDic = [NSMutableDictionary dictionaryWithDictionary:propDic];
            controller.backType = RTSelectorBackTypePopToRoot;
            [controller setHidesBottomBarWhenPushed:YES];
            [[[self.tabController controllerArrays] objectAtIndex:index] pushViewController:controller animated:YES];
            [controller showTopAlertWithTitle:message];
        }
            break;
        case SwitchType_RentBid: //租房竞价
        {
            RentBidDetailController *controller = [[RentBidDetailController alloc] init];
            [controller setHidesBottomBarWhenPushed:YES];
            [[[self.tabController controllerArrays] objectAtIndex:index] pushViewController:controller animated:YES];
            [controller showTopAlertWithTitle:message];
        }
            break;
        case SwitchType_SaleBid: //二手房竞价
        {
            SaleBidDetailController *controller = [[SaleBidDetailController alloc] init];
            [controller setHidesBottomBarWhenPushed:YES];
            [[[self.tabController controllerArrays] objectAtIndex:index] pushViewController:controller animated:YES];
            [controller showTopAlertWithTitle:message];
        }
            break;
        case SwitchType_RentNoPlan: //租房未推广
        {
            RentNoPlanController *controller = [[RentNoPlanController alloc] init];
            [controller setHidesBottomBarWhenPushed:YES];
            [[[self.tabController controllerArrays] objectAtIndex:index] pushViewController:controller animated:YES];
            [controller showTopAlertWithTitle:message];
        }
            break;
        case SwitchType_SaleNoPlan: //二手房未推广
        {
            SaleNoPlanGroupController *controller = [[SaleNoPlanGroupController alloc] init];
            [controller setHidesBottomBarWhenPushed:YES];
            [[[self.tabController controllerArrays] objectAtIndex:index] pushViewController:controller animated:YES];
            [controller showTopAlertWithTitle:message];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 101){
        if (buttonIndex == 0) {
            if (self.isEnforceUpdate) { //更新
                //            NSString *url = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=582908841&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
                
                exit(0); //强制更新后跳转且退出应用
            }
        }
        if (buttonIndex == 1) {
            if (self.isEnforceUpdate) { //退出应用
                exit(0);
            }
            else {
                //            NSString *url = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=582908841&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
            }
        }

    }else if (alertView.tag == 102){
        if (buttonIndex == 0) {

        }
        if (buttonIndex == 1) {
             //更新
                //            NSString *url = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=582908841&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
                
                exit(0); //强制更新后跳转且退出应用
            
        }
    
    }else{
    
    
    }
}

@end
