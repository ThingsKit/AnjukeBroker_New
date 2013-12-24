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
    self.view.backgroundColor =  [Util_UI colorWithHexString:@"#EFEFF4"];
    NSString *tempStr = [NSString stringWithFormat:@"当前限额：%@元/天",self.fixedObject.topCost];
    UILabel *labCurrentCeiling = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 320, 40)];
    labCurrentCeiling.textColor = [UIColor grayColor];
    labCurrentCeiling.backgroundColor = [UIColor clearColor];
    labCurrentCeiling.text = tempStr;
    labCurrentCeiling.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:labCurrentCeiling];
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 40)];
    content.backgroundColor = [UIColor whiteColor];
//    content.layer.borderWidth = 2;
//    content.layer.borderColor = [Util_UI colorWithHexString:@"#F9F9F9"].CGColor;
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
    tips.text = @"调整限额";
    tips.backgroundColor = [UIColor clearColor];
    [content addSubview:tips];
    UILabel *unit = [[UILabel alloc] initWithFrame:CGRectMake(260, 0, 40, 40)];
    unit.text = @"元/天";
    unit.textColor = [UIColor grayColor];
    unit.backgroundColor = [UIColor clearColor];
    [content addSubview:unit];
    UILabel *per = [[UILabel alloc] initWithFrame:CGRectMake(300, 0, 20, 40)];
    per.text = @"元";
    per.textColor = [UIColor clearColor];
    [content addSubview:per];
    self.totalCost = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 20)];
    self.totalCost.borderStyle = UITextBorderStyleNone;
    self.totalCost.backgroundColor = [UIColor clearColor];
    self.totalCost.text = self.fixedObject.topCost;
    //    totalCost.keyboardType = UIKeyboardTypeNumberPad;
    [self.totalCost becomeFirstResponder];
    [content addSubview:self.totalCost];
    [self.view addSubview:content];
    
    UILabel *labNotes = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 320, 40)];
    labNotes.backgroundColor = [UIColor clearColor];
    labNotes.text = @"限额至少为 10 元/天";
    labNotes.textColor = [UIColor grayColor];
    labNotes.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:labNotes];
    
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
