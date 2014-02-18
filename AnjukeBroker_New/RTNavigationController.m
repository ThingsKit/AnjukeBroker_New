//
//  RTNavigationViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-3.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTNavigationController.h"
#import "Util_UI.h"
#import "AppManager.h"

@interface RTNavigationController ()

@end

@implementation RTNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationBar.translucent = NO;
        if (![AppManager isIOS6]) {
//            self.navigationBar.barTintColor = SYSTEM_NAVIBAR_COLOR;
            
            self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"anjuke_icon_back.png"];
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

@end
