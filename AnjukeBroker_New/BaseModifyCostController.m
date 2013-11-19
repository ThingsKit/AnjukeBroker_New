//
//  BaseModifyCostController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/19/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseModifyCostController.h"
#import "Util_UI.h"

@interface BaseModifyCostController ()

@end

@implementation BaseModifyCostController
@synthesize fixedObject;
@synthesize totalCost;

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
-(void)initDisplay{
    [self setTitleViewWithString:@"调整限额"];
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    content.layer.borderWidth = 2;
    content.layer.borderColor = [Util_UI colorWithHexString:@"#F9F9F9"].CGColor;
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 40)];
    tips.text = @"限额";
    [content addSubview:tips];
    UILabel *per = [[UILabel alloc] initWithFrame:CGRectMake(300, 0, 20, 40)];
    per.text = @"元";
    per.textColor = [UIColor grayColor];
    [content addSubview:per];
    self.totalCost = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 200, 40)];
    self.totalCost.borderStyle = UITextBorderStyleNone;
    self.totalCost.text = self.fixedObject.topCost;
    //    totalCost.keyboardType = UIKeyboardTypeNumberPad;
    [self.totalCost becomeFirstResponder];
    [content addSubview:self.totalCost];
    [self.view addSubview:content];
    [self addRightButton:@"确定" andPossibleTitle:nil];
}
#pragma mark -- privateMethods

- (void)rightButtonAction:(id)sender{
    if(self.isLoading){
        return ;
    }
    //    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
