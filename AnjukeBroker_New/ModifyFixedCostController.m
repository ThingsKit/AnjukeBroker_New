//
//  ModifyFixedCostController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "ModifyFixedCostController.h"
#import "LoginManager.h"

@interface ModifyFixedCostController ()
{
}

@end

@implementation ModifyFixedCostController

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_MODIFY_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_MODIFY_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - View lifecycle
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
	// Do any additional setup after loading the view.
}

#pragma mark - 修改定价组限额
-(void)modifyFixedProperty{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", self.fixedObject.fixedId, @"planId", [NSString stringWithFormat:@"%@", self.totalCost.text], @"ceiling", self.fixedObject.planName, @"planName", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/updateplanceiling/" params:params target:self action:@selector(onModifySuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onModifySuccess:(RTNetworkResponse *)response {
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;

        return;
    }
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;

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
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_MODIFY_003 note:nil];
    if ([self.totalCost.text integerValue] <10 || [self.totalCost.text integerValue]>1000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"限额为10-1000元" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return ;
    }
    [super rightButtonAction:self];
    [self modifyFixedProperty];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)doBack:(id)sender{
    [super doBack:self];
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_MODIFY_004 note:nil];
}
@end
