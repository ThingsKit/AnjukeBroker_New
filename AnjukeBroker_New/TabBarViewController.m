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

#define tabItemInsertsMake UIEdgeInsetsMake(0, 0, 0, 0)
#define NAVITATION_BAR_TINITCOLOR [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1]

@interface TabBarViewController ()

@end

@implementation TabBarViewController
@synthesize page1, page2 ,page3, page4;

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
        NSMutableArray *controllerArrays = [NSMutableArray array]; //保留4个首页
                
        //add four nav controllers
        HomeViewController *hv = [[HomeViewController alloc] init];
        hv.isHome = YES;
        self.page1 = hv;
        UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:self.page1];
        nav1.navigationBar.barTintColor = NAVITATION_BAR_TINITCOLOR;
        nav1.navigationBar.translucent = NO;
        [controllerArrays addObject:nav1];
        
        AnjukeHomeViewController *av = [[AnjukeHomeViewController alloc] init];
        self.page2 = av;
        av.isHome = YES;
        UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:self.page2];
        nav2.navigationBar.barTintColor = NAVITATION_BAR_TINITCOLOR;
        nav2.navigationBar.translucent = NO;
        [controllerArrays addObject:nav2];
        
        HaozuHomeViewController *hhv = [[HaozuHomeViewController alloc] init];
        self.page3 = hhv;
        hhv.isHome = YES;
        UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:self.page3];
        nav3.navigationBar.barTintColor = NAVITATION_BAR_TINITCOLOR;
        nav3.navigationBar.translucent = NO;
        [controllerArrays addObject:nav3];
        
        MoreViewController *mv = [[MoreViewController alloc] init];
        self.page4 = mv;
        mv.isHome = YES;
        UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:self.page4];
        nav4.navigationBar.barTintColor = NAVITATION_BAR_TINITCOLOR;
        nav4.navigationBar.translucent = NO;
        [controllerArrays addObject:nav4];
        
        //set tabBarItems
        UITabBarItem *tb1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"TabHome_normal"] tag:1];
        tb1.imageInsets = tabItemInsertsMake;
        nav1.tabBarItem = tb1;
        
        UITabBarItem *tb2 = [[UITabBarItem alloc] initWithTitle:@"二手房" image:[UIImage imageNamed:@"TabAnjuke_normal"] tag:2];
        tb2.imageInsets = tabItemInsertsMake;
        nav2.tabBarItem = tb2;
        
        UITabBarItem *tb3 = [[UITabBarItem alloc] initWithTitle:@"租房" image:[UIImage imageNamed:@"TabHaozu_normal"] tag:3];
        tb3.imageInsets = tabItemInsertsMake;
        nav3.tabBarItem = tb3;
        
        UITabBarItem *tb4 = [[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"TabMore_normal"] tag:4];
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


@end
