//
//  AJK_TabBarViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-18.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "TabBarViewController.h"
//#import "AnjukeHomeViewController.h"
//#import "HaozuHomeViewController.h"
#import "RTGestureBackNavigationController.h"
#import "Util_UI.h"
//#import "AppManager.h"
//#import "FindHomeViewController.h"
#import "MessageListViewController.h"
//#import "ClientListViewController.h"
#import "BrokerLuanchAdd.h"
#import "UserCenterViewController.h"
#import "HomeViewController.h"

#define tabItemInsertsMake UIEdgeInsetsMake(0, 0, 0, 0)

@interface TabBarViewController ()
@property (nonatomic, strong) UIViewController *page1;
@property (nonatomic, strong) UIViewController *page2;
@property (nonatomic, strong) UIViewController *page3;
@property (nonatomic, strong) UIViewController *page4;
@property (nonatomic, strong) UIViewController *page5;

@property (nonatomic, strong) RTGestureBackNavigationController *messageNavController;

@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.delegate = self;
        self.controllerArrays = [NSMutableArray array]; //保留4个首页
        
        [[BrokerLuanchAdd sharedLuanchAdd] doRequst];
        
        //add four nav controllers
        //首页
        HomeViewController *hv = [[HomeViewController alloc] init];
        hv.isHome = YES;
        self.page1 = hv;
        self.HomeVC = hv;
        RTGestureBackNavigationController *navH = [[RTGestureBackNavigationController alloc] initWithRootViewController:self.page1];
        [self.controllerArrays addObject:navH];
        navH.tabBarItem = [self getTabBarItemWithTitle:@"首页" image:[UIImage imageNamed:@"tab_icon_home_normal"] index:1 selectedImg:[UIImage imageNamed:@"tab_icon_home_select"]];
        
        //微聊
        MessageListViewController *ml = [[MessageListViewController alloc] init];
        ml.isHome = YES;
        self.page2 = ml;
        RTGestureBackNavigationController *navMl = [[RTGestureBackNavigationController alloc] initWithRootViewController:ml];
        [self.controllerArrays addObject:navMl];
        navMl.tabBarItem = [self getTabBarItemWithTitle:@"微聊" image:[UIImage imageNamed:@"tab_icon_chat_normal"] index:2 selectedImg:[UIImage imageNamed:@"tab_icon_chat_select"]];
        self.messageNavController = navMl;

        UserCenterViewController *userVC = [[UserCenterViewController alloc] init];
        RTGestureBackNavigationController *userNav = [[RTGestureBackNavigationController alloc] initWithRootViewController:userVC];
        [self.controllerArrays addObject:userNav];
        userNav.tabBarItem = [self getTabBarItemWithTitle:@"我的" image:[UIImage imageNamed:@"tab_icon_user_normal"] index:5 selectedImg:[UIImage imageNamed:@"tab_icon_user_select"]];

        
        self.viewControllers = self.controllerArrays;
        
        //如果版本7.0或以上
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            [self.tabBar setTintColor:SYSTEM_TABBAR_SELECTCOLOR_DARK];
            [self.tabBar setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_tab_bg.png"]];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//    UIViewController *selectedController = ((RTGestureBackNavigationController *)[tabBarController selectedViewController]).visibleViewController;
//    UIViewController *newController = ((RTGestureBackNavigationController *)viewController).visibleViewController;
//    
//    //点击tab刷新VC数据
//    if ([newController isKindOfClass:[HomeViewController class]]&& [selectedController isKindOfClass:[newController class]]) {
//        [(HomeViewController *)newController doRequest];
//    }
//    else if ([newController isKindOfClass:[AnjukeHomeViewController class]]&& [selectedController isKindOfClass:[newController class]]) {
//        [(AnjukeHomeViewController *)selectedController doRequest];
//    }
//    else if ([newController isKindOfClass:[HaozuHomeViewController class]]&& [selectedController isKindOfClass:[newController class]]) {
//        [(HaozuHomeViewController *)selectedController doRequest];
//    }
//    else if ([newController isKindOfClass:[MessageListViewController class]]&& [selectedController isKindOfClass:[newController class]]) {
//        
//    }
//    else if ([newController isKindOfClass:[ClientListViewController class]]&& [selectedController isKindOfClass:[newController class]]) {
//        
//    }
//    
//    return YES;
//}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    DLog(@"class ---aaa--- %@", [viewController class]);
}

- (UITabBarItem *)getTabBarItemWithTitle:(NSString *)title image:(UIImage *)image index:(int)index selectedImg:(UIImage *)selectedImg{
    
    //如果版本7.0或以上
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    UITabBarItem *tabBarItem = nil;
    tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:index];
    tabBarItem.imageInsets = tabItemInsertsMake;
    tabBarItem.selectedImage = selectedImg;
    
    return tabBarItem;
}

- (void)setMessageBadgeValueWithValue:(NSString *)value {
    DLog(@"未读消息数量 【%@】", value);
    [self.messageNavController.tabBarItem setBadgeValue:value];
}


@end
