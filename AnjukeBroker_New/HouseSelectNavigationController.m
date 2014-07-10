//
//  houseSelectNavigationController.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-2-26.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "HouseSelectNavigationController.h"

@interface HouseSelectNavigationController ()

@end

@implementation HouseSelectNavigationController
@synthesize selectedHouseDelgate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
