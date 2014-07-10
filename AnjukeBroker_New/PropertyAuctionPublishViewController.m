//
//  PropertyAuctionPublishViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-18.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PropertyAuctionPublishViewController.h"
#import "AnjukePropertyResultController.h"
#import "AppDelegate.h"

@interface PropertyAuctionPublishViewController ()

@end

@implementation PropertyAuctionPublishViewController
@synthesize propertyID, commID;
@synthesize isHaozu;

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
    
    [self requestMiniOffer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)checkRank {
    [self doCheckRankWithPropID:self.propertyID commID:self.commID];
}

- (void)rightButtonAction:(id)sender { //发布竞价房源
    [self doRequest];
}

#pragma mark - Request Method

- (void)requestMiniOffer {
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", self.propertyID, @"propId", nil];
    
    if (self.isHaozu) {
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/bid/minoffer/" params:params target:self action:@selector(onMinSuccess:)];
    }
    else
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
    
    NSString *str = [NSString stringWithFormat:@"底价%@元", [[response content] objectForKey:@"data"]];
    self.textField_2.placeholder = str;
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}


-(void)doRequest{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    NSMutableDictionary *params = nil;
    
    if (self.isHaozu) { //租房
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getCity_id], @"cityId", [LoginManager getUserID], @"brokerId", self.propertyID, @"propId", self.textField_1.text, @"budget", self.textField_2.text, @"offer", nil];
    }
    else {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", self.propertyID, @"propId", self.textField_1.text, @"budget", self.textField_2.text, @"offer", nil];
    }
    
    NSString *methodStr = [NSString string];
    if (self.isHaozu) {
        methodStr = @"zufang/bid/addproptoplan/";
    }
    else
        methodStr = @"anjuke/bid/addproptoplan/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:methodStr params:params target:self action:@selector(onBidSuccess:)];
    [self showLoadingActivity:YES];
}

- (void)onBidSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"竞价失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        return;
    }
    
    [self hideLoadWithAnimated:YES];
    
    [self showInfo:@"竞价组房源发房成功"];
    
//    AnjukePropertyResultController *ap = [[AnjukePropertyResultController alloc] init];
//    if (self.isHaozu) {
//        ap.resultType = PropertyResultOfRentBid;
//    }
//    else
//        ap.resultType = PropertyResultOfSaleBid;
//    [self.navigationController pushViewController:ap animated:YES];
    
    int tabIndex = 0;
//    if (self.isHaozu) {
//        tabIndex = 2;
//    }
    
    if (self.isHaozu) {
        [[AppDelegate sharedAppDelegate].ppcDataShowVC dismissController:self withSwitchIndex:tabIndex withSwtichType:SwitchType_RentBid withPropertyDic:[NSDictionary dictionary]];
    }
    else
        
        
        [[AppDelegate sharedAppDelegate].ppcDataShowVC dismissController:self withSwitchIndex:tabIndex withSwtichType:SwitchType_SaleBid withPropertyDic:[NSDictionary dictionary]];
}

@end
