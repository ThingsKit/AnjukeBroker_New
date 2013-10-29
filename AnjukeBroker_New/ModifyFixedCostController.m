//
//  ModifyFixedCostController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "ModifyFixedCostController.h"

@interface ModifyFixedCostController ()

@end

@implementation ModifyFixedCostController

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
    [self setTitleViewWithString:@"修改限额"];
    UITextField *totalCost = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, 200, 30)];
    totalCost.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:totalCost];
    
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
    tips.text = @"请输入每日限额";
    [self.view addSubview:tips];
    
    UIButton *action = [UIButton buttonWithType:UIButtonTypeCustom];
    [action setTitle:@"确定" forState:UIControlStateNormal];
    [action addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchDown];
    [action setBackgroundColor:[UIColor lightGrayColor]];
    [action setFrame:CGRectMake(0, 0, 60, 40)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:action];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- privateMethods
-(void)action{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
