//
//  AJK_TabBarViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-18.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "TabBarViewController.h"
#import "AnjukeHomeViewController.h"
#import "HaozuHomeViewController.h"
#import "MoreViewController.h"
#import "RTGestureBackNavigationController.h"
#import "AppDelegate.h"
#import "Util_UI.h"
#import "AppManager.h"
#import "FindHomeViewController.h"
#import "MessageListViewController.h"
#import "ClientListViewController.h"

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
        
        //add four nav controllers
        //首页
        HomeViewController *hv = [[HomeViewController alloc] init];
        hv.isHome = YES;
        self.page1 = hv;
        self.HomeVC = hv;
        RTGestureBackNavigationController *navH = [[RTGestureBackNavigationController alloc] initWithRootViewController:self.page1];
        [self.controllerArrays addObject:navH];
        navH.tabBarItem = [self getTabBarItemWithTitle:@"首页" image:[UIImage imageNamed:@"anjuke_icon_home.png"] index:1 selectedImg:[UIImage imageNamed:@"anjuke_icon_home1.png"]];
        
        //微聊
        MessageListViewController *ml = [[MessageListViewController alloc] init];
        ml.isHome = YES;
        self.page2 = ml;
        RTGestureBackNavigationController *navMl = [[RTGestureBackNavigationController alloc] initWithRootViewController:ml];
        [self.controllerArrays addObject:navMl];
        navMl.tabBarItem = [self getTabBarItemWithTitle:@"微聊" image:[UIImage imageNamed:@"anjuke_icon_wl.png"] index:2 selectedImg:[UIImage imageNamed:@"anjuke_icon_wl1.png"]];
        self.messageNavController = navMl;
        
        //客户
        ClientListViewController *cl = [[ClientListViewController alloc] init];
        cl.isHome = YES;
        self.page3 = cl;
        RTGestureBackNavigationController *navCl = [[RTGestureBackNavigationController alloc] initWithRootViewController:cl];
        [self.controllerArrays addObject:navCl];
        navCl.tabBarItem = [self getTabBarItemWithTitle:@"客户" image:[UIImage imageNamed:@"anjuke_icon_kh.png"] index:3 selectedImg:[UIImage imageNamed:@"anjuke_icon_kh1.png"]];
        
        //二手房
        AnjukeHomeViewController *av = [[AnjukeHomeViewController alloc] init];
        self.page4 = av;
        av.isHome = YES;
        RTGestureBackNavigationController *navAJK = [[RTGestureBackNavigationController alloc] initWithRootViewController:av];
        [self.controllerArrays addObject:navAJK];
        navAJK.tabBarItem = [self getTabBarItemWithTitle:@"二手房" image:[UIImage imageNamed:@"anjuke_icon_esf.png"] index:4 selectedImg:[UIImage imageNamed:@"anjuke_icon_esf1.png"]];
        
        //租房
        HaozuHomeViewController *hhv = [[HaozuHomeViewController alloc] init];
        self.page5 = hhv;
        hhv.isHome = YES;
        RTGestureBackNavigationController *navHZ = [[RTGestureBackNavigationController alloc] initWithRootViewController:hhv];
        [self.controllerArrays addObject:navHZ];
        navHZ.tabBarItem = [self getTabBarItemWithTitle:@"租房" image:[UIImage imageNamed:@"anjuke_icon_zf.png"] index:5 selectedImg:[UIImage imageNamed:@"anjuke_icon_zf1.png"]];
        
        self.viewControllers = self.controllerArrays;
        
        if (![AppManager isIOS6]) {
            [self.tabBar setTintColor:SYSTEM_TABBAR_SELECTCOLOR_DARK];
            [self.tabBar setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_tab_bg.png"]];
        }
//        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEM_TABBAR_SELECTCOLOR_DARK, UITextAttributeTextColor, nil] forState:UIControlStateHighlighted];
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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UIViewController *selectedController = ((RTGestureBackNavigationController *)[tabBarController selectedViewController]).visibleViewController;
    UIViewController *newController = ((RTGestureBackNavigationController *)viewController).visibleViewController;
    
    //点击tab刷新VC数据
    if ([newController isKindOfClass:[HomeViewController class]]&& [selectedController isKindOfClass:[newController class]]) {
        [(HomeViewController *)newController doRequest];
    }
    else if ([newController isKindOfClass:[AnjukeHomeViewController class]]&& [selectedController isKindOfClass:[newController class]]) {
        [(AnjukeHomeViewController *)selectedController doRequest];
    }
    else if ([newController isKindOfClass:[HaozuHomeViewController class]]&& [selectedController isKindOfClass:[newController class]]) {
        [(HaozuHomeViewController *)selectedController doRequest];
    }
    else if ([newController isKindOfClass:[MessageListViewController class]]&& [selectedController isKindOfClass:[newController class]]) {
        
    }
    else if ([newController isKindOfClass:[ClientListViewController class]]&& [selectedController isKindOfClass:[newController class]]) {
        
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    DLog(@"class ---aaa--- %@", [viewController class]);
}

- (UITabBarItem *)getTabBarItemWithTitle:(NSString *)title image:(UIImage *)image index:(int)index selectedImg:(UIImage *)selectedImg{
    
    if (![AppManager isIOS6]) {
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
