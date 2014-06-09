//
//  WXDataViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "WXDataViewController.h"
#import "UserCenterModel.h"
#import "HUDNews.h"

@interface WXDataViewController ()
@property(nonatomic,strong) UserCenterModel *userCenterModel;
@end

@implementation WXDataViewController
@synthesize progressView;
@synthesize totalCustomer;
@synthesize totalResponseTime;
@synthesize userCenterModel;
@synthesize timer;

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
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    [self setTitleViewWithString:@"微聊数据"];
    
    [self initProgress];
    
    //初始化数字Label
    self.numberLabel.text = @"0";
    
    
    
    [self doRequest];
}

- (void)initProgress{
    self.progressView.progress = 0.0;
    self.progressView.thicknessRatio = 0.15;
    self.progressView.showShadow = NO;
    self.progressView.innerBackgroundColor = [UIColor whiteColor];
    self.progressView.outerBackgroundColor = [UIColor lightGrayColor];
    self.progressView.showText = NO;
    self.progressView.roundedHead = YES;
    self.progressView.progressTopGradientColor = [UIColor brokerBlueColor];
}

#pragma mark - Request Method
- (void)doRequest {
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];
        self.isLoading = NO;
        return;
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    //    method = @"broker/getsalemanager/";
    method = @"broker/callAnalysis/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}
- (void)onRequestFinished:(RTNetworkResponse *)response {
    DLog(@"response----->> [%@/%@]",[[response content] objectForKey:@"message"], [response content]);
    
    if([[response content] count] == 0){
        self.isLoading = NO;
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];
        //        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"服务器开溜了" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];
        return;
    }
    
    NSDictionary *clientDic = [[NSDictionary alloc] initWithDictionary:[[response content] objectForKey:@"data"]];
    self.userCenterModel = [UserCenterModel convertToMappedObject:clientDic];
    
    if (self.userCenterModel && self.userCenterModel.replyRate) {
        [self performSelector:@selector(showProgress) withObject:nil afterDelay:0.5];
        self.totalCustomer.text = [NSString stringWithFormat:@"%@",self.userCenterModel.customNum];
        self.totalResponseTime.text = [NSString stringWithFormat:@"%.1f",[self.userCenterModel.responseTime floatValue]];
    }
    
    self.isLoading = NO;
}
- (void)showProgress{
    self.progressView.progress = 0.0;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001
                                                  target:self
                                                selector:@selector(addProgress:)
                                                userInfo:@{@"test":@"1"}
                                                 repeats:YES];
}

- (void)addProgress:(NSTimer*) time{
    NSLog(@"%@", time.userInfo);
    if (self.progressView.progress >= 80.0/100) {
        [self.timer invalidate];
        return;
    }
//    if (self.progressView.progress >= [self.userCenterModel.replyRate doubleValue]/100) {
//        [self.timer invalidate];
//        return;
//    }
    if (self.progressView.progress + 0.2 > 0.8) {
         self.progressView.progress = self.progressView.progress + 0.0035;
    }else{
        self.progressView.progress = self.progressView.progress + 0.006;
    }
    
    self.numberLabel.text = [NSString stringWithFormat:@"%.0f", self.progressView.progress * 100];
    
    DLog(@"self.progressView.progress-->>%f",self.progressView.progress);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.timer invalidate];
}

@end
