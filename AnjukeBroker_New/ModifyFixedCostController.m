//
//  ModifyFixedCostController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "ModifyFixedCostController.h"
#import "Util_UI.h"

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
    [self setTitleViewWithString:@"调整限额"];
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    content.layer.borderWidth = 1;
    content.layer.borderColor = [Util_UI colorWithHexString:@"#666666"].CGColor;
    
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 40)];
    tips.text = @"限额";
    [content addSubview:tips];
    
    UILabel *per = [[UILabel alloc] initWithFrame:CGRectMake(300, 0, 20, 40)];
    per.text = @"元";
    per.textColor = [UIColor grayColor];
    [content addSubview:per];
    
    UITextField *totalCost = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 200, 40)];
    totalCost.borderStyle = UITextBorderStyleNone;
//    totalCost.keyboardType = UIKeyboardTypeNumberPad;
    [totalCost becomeFirstResponder];
    [content addSubview:totalCost];
    
    [self.view addSubview:content];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"确定"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(action)];
    self.navigationItem.rightBarButtonItem = editButton;

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- privateMethods
-(void)action{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}
@end
