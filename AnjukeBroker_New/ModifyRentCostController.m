//
//  ModifyRentCostController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/19/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "ModifyRentCostController.h"
#import "LoginManager.h"


@interface ModifyRentCostController ()

@end

@implementation ModifyRentCostController

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
- (void)initDisplay{
    [super initDisplay];

}
- (void)setCeiling{


}
#pragma mark - 修改定价组限额
-(void)modifyFixedProperty{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", self.fixedObject.fixedId, @"planId", [NSString stringWithFormat:@"%@", self.totalCost.text], @"ceiling", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/updateplanceiling/" params:params target:self action:@selector(onModifySuccess:)];
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
    if ([self.totalCost.text integerValue] <10 || [self.totalCost.text integerValue]>1000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"限额为10-1000元" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return ;
    }
    [super rightButtonAction:self];
    [self modifyFixedProperty];
    //    [self.navigationController popViewControllerAnimated:YES];
}
@end
