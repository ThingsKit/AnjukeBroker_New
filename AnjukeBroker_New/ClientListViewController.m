//
//  ClientListViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "ClientListViewController.h"

@interface ClientListViewController ()

@end

@implementation ClientListViewController

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
    
    [self setTitleViewWithString:@"我的客户"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
