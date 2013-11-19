//
//  RentAuctionViewController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/18/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentAuctionViewController.h"
#import "SaleFixedDetailController.h"
#import "SaleBidDetailController.h"
#import "SalePropertyListController.h"

@interface RentAuctionViewController ()

@end

@implementation RentAuctionViewController
@synthesize proDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initModel_];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"设置竞价"];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doRequestMinoffer];
}
- (void)initModel_ {
    self.proDic = [[NSDictionary alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 设置竞价额度
-(void)doResetBid{
    if(![self isNetworkOkay]){
        return;
    }
    //    NSString *tempstr = [NSString stringWithFormat:@"%@",[self.proDic objectForKey:@"propId"]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.proDic objectForKey:@"id"], @"propId", self.textField_1.text, @"budget", self.textField_2.text, @"offer", nil];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/editplan/" params:params target:self action:@selector(onBidResetSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onBidResetSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"竞价失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
    [self doSure];
}
#pragma mark - 获取竞价底价
-(void)doRequestMinoffer{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.proDic objectForKey:@"id"], @"propId", nil];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/minoffer/" params:params target:self action:@selector(onMinSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onMinSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取底价失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    self.textField_2.text = [[response content] objectForKey:@"data"];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
    [self doSure];
}

#pragma mark - 设置竞价额度
-(void)doRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.proDic objectForKey:@"id"], @"propId", self.textField_1.text, @"budget", self.textField_2.text, @"offer", nil];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/addproptoplan/" params:params target:self action:@selector(onBidSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onBidSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"竞价失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
    [self doSure];
}

#pragma mark - 根据房源信息估算排名
-(void)doCheckRank{
    if(![self isNetworkOkay]){
        return;
    }
    [self doCheckRankWithPropID:[self.proDic objectForKey:@"id"] commID:[self.proDic objectForKey:@"commId"]];
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", [self.proDic objectForKey:@"id"], @"propId", [self.proDic objectForKey:@"commId"], @"commId", self.textField_2.text, @"offer", nil];
//    
//    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/getrank/" params:params target:self action:@selector(onCheckSuccess:)];
//    [self showLoadingActivity:YES];
//    self.isLoading = YES;
}

//- (void)onCheckSuccess:(RTNetworkResponse *)response {
//    DLog(@"------response [%@]", [response content]);
//    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
//        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alert show];
//        [self hideLoadWithAnimated:YES];
//        self.isLoading = NO;
//        
//        return;
//    }
//    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[response content]];
//    if([resultFromAPI count] == 0){
//        [self hideLoadWithAnimated:YES];
//        self.isLoading = NO;
//        
//        return ;
//    }
//    [self hideLoadWithAnimated:YES];
//    self.isLoading = NO;
//    
//    
//    self.rangLabel.alpha = 0.0;
//    //test
//    self.rangLabel.text = [NSString stringWithFormat:@"预估排名:第%@名",[resultFromAPI objectForKey:@"data"]];
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:.3];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    self.rangLabel.alpha = 1;
//    [UIView commitAnimations];
//}
#pragma mark - 重新开始竞价推广
-(void)doRestartBid{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.proDic objectForKey:@"id"], @"propId", self.textField_1.text, @"budget", self.textField_2.text, @"offer", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/spreadstart/" params:params target:self action:@selector(onRestartSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}
- (void)onRestartSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
    //    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
    [self doSure];
}
- (void)rightButtonAction:(id)sender {
    if(self.isLoading){
        return ;
    }
    if([self.delegateVC isKindOfClass:[SaleBidDetailController class]]){
        if([[self.proDic objectForKey:@"bidStatus"] isEqualToString:@"3"]){//当竞价为手动暂停状态时可重新参与竞价
            [self doRestartBid];
            return ;
        }
        [self doResetBid];//修改竞价出价及额度
    }else
        [self doRequest];//定价组房源参与竞价
    
}

- (void)doSure {
    
    //test
    if ([self.delegateVC isKindOfClass:[SaleBidDetailController class]] || [self.delegateVC isKindOfClass:[SaleFixedDetailController class]] || [self.delegateVC isKindOfClass:[SalePropertyListController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (self.navigationController) {
        //        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)checkRank {
    [self doCheckRank];
}

@end
