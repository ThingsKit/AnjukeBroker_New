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

#define tabItemInsertsMake UIEdgeInsetsMake(0, 0, 0, 0)

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
        RTNavigationController *nav1 = [[RTNavigationController alloc] initWithRootViewController:self.page1];
        [controllerArrays addObject:nav1];
        
        AnjukeHomeViewController *av = [[AnjukeHomeViewController alloc] init];
        self.page2 = av;
        av.isHome = YES;
        RTNavigationController *nav2 = [[RTNavigationController alloc] initWithRootViewController:self.page2];
        [controllerArrays addObject:nav2];
        
        HaozuHomeViewController *hhv = [[HaozuHomeViewController alloc] init];
        self.page3 = hhv;
        hhv.isHome = YES;
        RTNavigationController *nav3 = [[RTNavigationController alloc] initWithRootViewController:self.page3];
        [controllerArrays addObject:nav3];
        
        MoreViewController *mv = [[MoreViewController alloc] init];
        self.page4 = mv;
        mv.isHome = YES;
        RTNavigationController *nav4 = [[RTNavigationController alloc] initWithRootViewController:self.page4];
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
