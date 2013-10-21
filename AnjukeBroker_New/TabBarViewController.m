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

#define tabItemInsertsMake UIEdgeInsetsMake(6, 0, -6, 0)

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
        self.page1 = hv;
        UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:self.page1];
        [controllerArrays addObject:nav1];
        
        AnjukeHomeViewController *av = [[AnjukeHomeViewController alloc] init];
        self.page2 = av;
        UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:self.page2];
        [controllerArrays addObject:nav2];
        
        HaozuHomeViewController *hhv = [[HaozuHomeViewController alloc] init];
        self.page3 = hhv;
        UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:self.page3];
        [controllerArrays addObject:nav3];
        
        MoreViewController *mv = [[MoreViewController alloc] init];
        self.page4 = mv;
        UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:self.page4];
        [controllerArrays addObject:nav4];
        
        //set tabBarItems
        UITabBarItem *tb1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:nil tag:1];
        tb1.imageInsets = tabItemInsertsMake;
        nav1.tabBarItem = tb1;
        
        UITabBarItem *tb2 = [[UITabBarItem alloc] initWithTitle:@"二手房" image:nil tag:2];
        tb2.imageInsets = tabItemInsertsMake;
        nav2.tabBarItem = tb2;
        
        UITabBarItem *tb3 = [[UITabBarItem alloc] initWithTitle:@"租房" image:nil tag:3];
        tb3.imageInsets = tabItemInsertsMake;
        nav3.tabBarItem = tb3;
        
        UITabBarItem *tb4 = [[UITabBarItem alloc] initWithTitle:@"更多" image:nil tag:4];
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
