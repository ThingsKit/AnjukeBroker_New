//
//  SaleBidPlanController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleBidPlanController.h"

@interface SaleBidPlanController ()
{
    UIButton *calculation;
    UILabel *result;
    UITextField *budgetValue;
    UITextField *priceValue;
}
@end

@implementation SaleBidPlanController

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
    [self setTitleViewWithString:@"设置竞价"];
    
    UIButton *action = [UIButton buttonWithType:UIButtonTypeCustom];
    [action setTitle:@"确定" forState:UIControlStateNormal];
    [action addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchDown];
    [action setBackgroundColor:[UIColor lightGrayColor]];
    [action setFrame:CGRectMake(0, 0, 60, 40)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:action];

    
    UILabel *budget = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 300, 20)];
    budget.text = @"预算                                       最低20元";
    [self.view addSubview:budget];
    
    budget = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 300, 20)];
    budget.text = @"出价                                       最低6.1元";
    [self.view addSubview:budget];
    
    budgetValue = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 300, 30)];
    budgetValue.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:budgetValue];
    
    priceValue = [[UITextField alloc] initWithFrame:CGRectMake(10, 160, 300, 30)];
    priceValue.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:priceValue];
    
    result = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 30)];
    [result setBackgroundColor:[UIColor clearColor]];
    result.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:result];
    
    calculation = [UIButton buttonWithType:UIButtonTypeCustom];
    calculation.frame = CGRectMake(10, 200, 300, 40);
    [calculation setBackgroundColor:[UIColor lightGrayColor]];
    [calculation setTitle:@"估算排名" forState:UIControlStateNormal];
    [calculation addTarget:self action:@selector(calculation) forControlEvents:UIControlEventTouchDown];
    
    
    [self.view addSubview:calculation];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- PrivateMethod
-(void)calculation{
    result.text = @"第2名";
    calculation.frame = CGRectMake(10, 250, 300, 40);
    [budgetValue resignFirstResponder];
    [priceValue resignFirstResponder];
}
-(void)action{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
