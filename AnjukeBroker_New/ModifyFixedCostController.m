//
//  ModifyFixedCostController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "ModifyFixedCostController.h"
#import "LoginManager.h"
#import "Util_UI.h"

@interface ModifyFixedCostController ()
{
}
@property (strong, nonatomic) UITextField *totalCost;
@end

@implementation ModifyFixedCostController
@synthesize fixedObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fixedObject = [[FixedObject alloc] init];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
	// Do any additional setup after loading the view.
}

#pragma mark - 取消定价推广房源
-(void)modifyFixedProperty{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", self.fixedObject.fixedId, @"planId", [NSString stringWithFormat:@"%@", self.totalCost.text], @"ceiling", self.fixedObject.planName, @"planName", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/updateplanceiling/" params:params target:self action:@selector(onModifySuccess:)];
    [self showLoadingActivity:YES];
}

- (void)onModifySuccess:(RTNetworkResponse *)response {
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        return;
    }
    [self hideLoadWithAnimated:YES];
    NSLog(@"-...-----response [%@]", [response content]);
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- privateMethods

- (void)rightButtonAction:(id)sender{
    [self modifyFixedProperty];
//    [self.navigationController popViewControllerAnimated:YES];
}
@end
