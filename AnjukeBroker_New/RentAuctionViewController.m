//
//  RentAuctionViewController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/19/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentAuctionViewController.h"
#import "RentFixedDetailController.h"
#import "RentBidDetailController.h"
#import "RentFixedDetailController.h"
#import "SalePropertyListController.h"

@interface RentAuctionViewController ()

@end

@implementation RentAuctionViewController
@synthesize proDic;

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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initValue];
    [self doRequestMinoffer];
}
-(void)initValue{
//    self.textField_1 = [self.proDic objectForKey:@"budget"];
//    self.textField_2 = [self.proDic objectForKey:@"offer"];
}
#pragma mark - 设置竞价额度
-(void)doBid{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.proDic objectForKey:@"id"], @"propId", [LoginManager getCity_id], @"cityId", self.textField_1.text, @"budget", self.textField_2.text, @"offer", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/bid/addproptoplan/" params:params target:self action:@selector(onBidSuccess:)];
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
#pragma mark - 重新开始竞价
-(void)doRestartBid{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.proDic objectForKey:@"id"], @"propId", [LoginManager getCity_id], @"cityId", self.textField_1.text, @"budget", self.textField_2.text, @"offer", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/bid/spreadstart/" params:params target:self action:@selector(onRestartSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onRestartSuccess:(RTNetworkResponse *)response {
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
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [self.proDic objectForKey:@"id"], @"propId", nil];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/bid/minoffer/" params:params target:self action:@selector(onMinSuccess:)];
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
    self.textField_2.placeholder = [NSString stringWithFormat:@"底价%@元",[[response content] objectForKey:@"data"]];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}
#pragma mark - 重新设置竞价
-(void)doResetBid{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.proDic objectForKey:@"id"], @"propId", self.textField_1.text, @"budget", self.textField_2.text, @"offer", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/bid/editplan/" params:params target:self action:@selector(onResetSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onResetSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取底价失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    self.textField_2.placeholder = [NSString stringWithFormat:@"底价%@元",[[response content] objectForKey:@"data"]];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    [self doSure];
}
#pragma mark - 修改竞价
-(void)doModifyBid{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.proDic objectForKey:@"id"], @"propId", self.textField_1.text, @"budget", self.textField_2.text, @"offer", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/bid/editplan/" params:params target:self action:@selector(onModifySuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onModifySuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取底价失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    self.textField_2.placeholder = [NSString stringWithFormat:@"底价%@元",[[response content] objectForKey:@"data"]];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    [self doSure];
}

#pragma mark - 根据房源信息估算排名
-(void)doCheckRank{
    if(![self isNetworkOkay]){
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", [self.proDic objectForKey:@"id"], @"propId", [self.proDic objectForKey:@"commId"], @"commId", self.textField_2.text, @"offer", nil];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/bid/getrank/" params:params target:self action:@selector(onCheckSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onCheckSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[response content]];
    if([resultFromAPI count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return ;
    }
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
    
    self.rangLabel.alpha = 0.0;
    //test
    self.rangLabel.text = [NSString stringWithFormat:@"预估排名:第%@名",[resultFromAPI objectForKey:@"data"]];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.rangLabel.alpha = 1;
    [UIView commitAnimations];
}
- (void)checkRank {
    [self doCheckRank];
}
- (void)rightButtonAction:(id)sender {
    if(self.isLoading){
        return ;
    }
    if([self.delegateVC isKindOfClass:[RentBidDetailController class]]){
        if([[self.proDic objectForKey:@"bidStatus"] isEqualToString:@"3"]){//当竞价为手动暂停状态时可重新参与竞价
            [self doRestartBid];
            return ;
        }else if ([[self.proDic objectForKey:@"bidStatus"] isEqualToString:@"1"]){
            [self doModifyBid];
            return;
        }
        [self doResetBid];//修改竞价出价及额度
    }else
        [self doBid];//定价组房源参与竞价
}

- (void)doSure {
    
    //test
    if ([self.delegateVC isKindOfClass:[RentBidDetailController class]] || [self.delegateVC isKindOfClass:[RentFixedDetailController class]] || [self.delegateVC isKindOfClass:[SalePropertyListController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (self.navigationController) {
        //        [self.navigationController popToRootViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
