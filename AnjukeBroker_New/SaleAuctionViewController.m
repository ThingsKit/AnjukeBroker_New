//
//  RentAuctionViewController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/18/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleAuctionViewController.h"
#import "SaleFixedDetailController.h"
#import "SaleBidDetailController.h"
#import "SalePropertyListController.h"

@interface SaleAuctionViewController ()
@property (strong, nonatomic) NSString *bottomOffer;
@end

@implementation SaleAuctionViewController
@synthesize proDic;
@synthesize bottomOffer;

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_AUCTION_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_AUCTION_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - View lifecycle
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
    self.textField_1.text = [self.proDic objectForKey:@"budget"];
    self.textField_2.text = [self.proDic objectForKey:@"offer"];
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
#pragma mark - 重新设置竞价额度
-(void)doResetBid{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
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
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"竞价失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_BID_DETAIL_008 note:[NSDictionary dictionaryWithObjectsAndKeys:@"false", @"jj_s", nil]];
        return;
    }
    if([[[response content] objectForKey:@"status"] isEqualToString:@"ok"]){
        [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_BID_DETAIL_008 note:[NSDictionary dictionaryWithObjectsAndKeys:@"true", @"jj_s", nil]];
    }
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
    [self doSure];
}
#pragma mark - 获取竞价底价
-(void)doRequestMinoffer{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.proDic objectForKey:@"id"], @"propId", nil];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/minoffer/" params:params target:self action:@selector(onMinSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onMinSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取底价失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    self.textField_2.placeholder = [NSString stringWithFormat:@"底价%@元",[[response content] objectForKey:@"data"]];
    self.bottomOffer = [NSString stringWithFormat:@"%@", [[response content] objectForKey:@"data"]];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

#pragma mark - 开始竞价
-(void)doRequest{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.proDic objectForKey:@"id"], @"propId", self.textField_1.text, @"budget", self.textField_2.text, @"offer", nil];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/addproptoplan/" params:params target:self action:@selector(onBidSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onBidSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"竞价失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_AUCTION_004 note:[NSDictionary dictionaryWithObjectsAndKeys:@"false", @"jj_s", nil]];
        return;
    }
    if([[[response content] objectForKey:@"status"] isEqualToString:@"ok"]){
        [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_AUCTION_004 note:[NSDictionary dictionaryWithObjectsAndKeys:@"true", @"jj_s", nil]];
    }
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
    [self doSure];
}

#pragma mark - 根据房源信息估算排名
-(void)doCheckRank{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    [self doCheckRankWithPropID:[self.proDic objectForKey:@"id"] commID:[self.proDic objectForKey:@"commId"]];

}

#pragma mark - 重新开始竞价推广
-(void)doRestartBid{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.proDic objectForKey:@"id"], @"propId", self.textField_1.text, @"budget", self.textField_2.text, @"offer", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/spreadstart/" params:params target:self action:@selector(onRestartSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onRestartSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_BID_DETAIL_008 note:[NSDictionary dictionaryWithObjectsAndKeys:@"false", @"jj_s", nil]];
        return;
    }
    if([[[response content] objectForKey:@"status"] isEqualToString:@"ok"]){
        [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_BID_DETAIL_008 note:[NSDictionary dictionaryWithObjectsAndKeys:@"true", @"jj_s", nil]];
    }
    //    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
    [self doSure];
}
- (void)rightButtonAction:(id)sender {
    if(self.textField_1.text == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写预算" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return ;
    }else if (self.textField_2.text == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写出价" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return ;
    }else if ([self.textField_1.text integerValue] < 20){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"预算不得低于20元" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return ;
    }else if ([self.textField_2.text integerValue] < [self.bottomOffer integerValue]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"出价不得低于底价" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return ;
    }else if ([self.textField_2.text integerValue] > [self.textField_1.text integerValue]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"预算不得低于出价" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return ;
    }
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
        [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_AUCTION_005 note:nil];
    if([self.textField_2.text floatValue] < [self.bottomOffer floatValue]){
        [self showInfo:[NSString stringWithFormat:@"出价不得低于底价%@元", self.bottomOffer]];
        return ;
    }
    [self doCheckRank];
}
- (void)doBack:(id)sender{
    [super doBack:self];
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_AUCTION_003 note:nil];
}
@end
