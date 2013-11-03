//
//  RTNavigationViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-3.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTNavigationController.h"

@interface RTNavigationController ()

@end

#define NAVITATION_BAR_TINITCOLOR [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1]

@implementation RTNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationBar.translucent = NO;
        self.navigationBar.barTintColor = NAVITATION_BAR_TINITCOLOR;
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

@end
