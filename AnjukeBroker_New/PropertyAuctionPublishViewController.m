//
//  PropertyAuctionPublishViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-18.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PropertyAuctionPublishViewController.h"

@interface PropertyAuctionPublishViewController ()

@end

@implementation PropertyAuctionPublishViewController
@synthesize propertyID, commID;

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
-(void)doRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", self.propertyID, @"propId", self.textField_1.text, @"budget", self.textField_2.text, @"offer", nil];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/addproptoplan/" params:params target:self action:@selector(onBidSuccess:)];
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
