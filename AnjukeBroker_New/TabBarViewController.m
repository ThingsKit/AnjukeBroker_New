//
//  AJK_TabBarViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-18.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "AnjukeHomeViewController.h"
#import "HaozuHomeViewController.h"
#import "MoreViewController.h"
#import "RTNavigationController.h"
#import "AppDelegate.h"

#define tabItemInsertsMake UIEdgeInsetsMake(0, 0, 0, 0)

@interface TabBarViewController ()
@property (nonatomic, strong) UIViewController *page1;
@property (nonatomic, strong) UIViewController *page2;
@property (nonatomic, strong) UIViewController *page3;
@property (nonatomic, strong) UIViewController *page4;

@end

@implementation TabBarViewController
@synthesize page1, page2 ,page3, page4;
@synthesize controllerArrays;

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
        HomeViewController *hv = [[HomeViewController alloc] init];
        hv.isHome = YES;
        self.page1 = hv;
        RTNavigationController *nav1 = [[RTNavigationController alloc] initWithRootViewController:self.page1];
        [self.controllerArrays addObject:nav1];
        
        AnjukeHomeViewController *av = [[AnjukeHomeViewController alloc] init];
        self.page2 = av;
        av.isHome = YES;
        RTNavigationController *nav2 = [[RTNavigationController alloc] initWithRootViewController:self.page2];
        [self.controllerArrays addObject:nav2];
        
        HaozuHomeViewController *hhv = [[HaozuHomeViewController alloc] init];
        self.page3 = hhv;
        hhv.isHome = YES;
        RTNavigationController *nav3 = [[RTNavigationController alloc] initWithRootViewController:self.page3];
        [self.controllerArrays addObject:nav3];
        
        MoreViewController *mv = [[MoreViewController alloc] init];
        self.page4 = mv;
        mv.isHome = YES;
        RTNavigationController *nav4 = [[RTNavigationController alloc] initWithRootViewController:self.page4];
        [self.controllerArrays addObject:nav4];
        
        //set tabBarItems
        UITabBarItem *tb1 = nil;
        tb1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"TabHome_normal"] selectedImage:[UIImage imageNamed:@"anjuke_icon11_home_selected.png"]];
        tb1.imageInsets = tabItemInsertsMake;
        
        nav1.tabBarItem = tb1;
        
        UITabBarItem *tb2 = nil;
        tb2 = [[UITabBarItem alloc] initWithTitle:@"二手房" image:[UIImage imageNamed:@"TabAnjuke_normal"] selectedImage:[UIImage imageNamed:@"anjuke_icon22_esf.png"]];
        tb2.imageInsets = tabItemInsertsMake;
        nav2.tabBarItem = tb2;
        
        UITabBarItem *tb3 = nil;
        tb3 = [[UITabBarItem alloc] initWithTitle:@"租房" image:[UIImage imageNamed:@"TabHaozu_normal"] selectedImage:[UIImage imageNamed:@"anjuke_icon33_zf_selected.png"]];
        tb3.imageInsets = tabItemInsertsMake;
        nav3.tabBarItem = tb3;
        
        UITabBarItem *tb4 = nil;
        tb4 =[[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"TabMore_normal"] selectedImage:[UIImage imageNamed:@"anjuke_icon44_more_selected.png"]];
        tb4.imageInsets = tabItemInsertsMake;
        nav4.tabBarItem = tb4;

        
        self.viewControllers = controllerArrays;
//        [self.tabBar setBarStyle:UIBarStyleDefault];
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
    UIViewController *selectedController = ((RTNavigationController *)[tabBarController selectedViewController]).visibleViewController;
    UIViewController *newController = ((RTNavigationController *)viewController).visibleViewController;
    
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
    else if ([newController isKindOfClass:[MoreViewController class]]&& [selectedController isKindOfClass:[newController class]]) {
//        [(MoreViewController *)selectedController requestNewsByPageOne];
    }
    
    return YES;
}

@end
