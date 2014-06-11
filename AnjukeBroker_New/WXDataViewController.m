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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wakeFromBackGound:) name:UIApplicationWillEnterForegroundNotification object:nil];

    }
    return self;
}
- (void)wakeFromBackGound:(NSNotification *)notification{
    [self doRequest];
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
    
    for (int i = 0; i < 10; i++) {
        int j = i / 5;
        int k = i % 5;
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.tag = 100 + i;
        imgView.frame = CGRectMake(97 + k * 28, 160 + j * 45, 14, 35);
        [imgView setImage:[UIImage imageNamed:@"broker_wlsj_nomen"]];
        [self.view addSubview:imgView];
    }
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
    NSString *status;
    
    if (self.progressView.progress > [self.userCenterModel.replyRate doubleValue]/100) {
        status = @"1";
    }else{
        status = @"0";
    }
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:status forKey:@"status"];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001
                                                  target:self
                                                selector:@selector(addProgress:)
                                                userInfo:dic
                                                 repeats:YES];
}

- (void)addProgress:(NSTimer*) time{
    NSLog(@"%@", time.userInfo);
    //测试部分数据
//    if (self.progressView.progress >= 0.83) {
    if (self.progressView.progress >= [self.userCenterModel.replyRate doubleValue]*0.01) {
        [self.timer invalidate];
        return;
    }
    
    BOOL status = [[timer.userInfo objectForKey:@"status"] isEqualToString:@"1"] ? YES : NO;
    
    float progress = self.progressView.progress/([self.userCenterModel.replyRate doubleValue]*0.01);
    
    DLog(@"progress--->>%0.f/%0.f/%0.f",progress,self.progressView.progress,[self.userCenterModel.replyRate doubleValue]*0.01);
    
    if (progress > 0.9) {
        if (status) {
            self.progressView.progress = self.progressView.progress - 0.003;
        }else{
            self.progressView.progress = self.progressView.progress + 0.003;
        }
    }else if (progress > 0.6){
        if (status) {
            self.progressView.progress = self.progressView.progress - 0.005;
        }else{
            self.progressView.progress = self.progressView.progress + 0.005;
        }
    }else if (progress > 0.2){
        if (status) {
            self.progressView.progress = self.progressView.progress - 0.004;
        }else{
            self.progressView.progress = self.progressView.progress + 0.004;
        }
    }else{
        if (status) {
            self.progressView.progress = self.progressView.progress - 0.002;
        }else{
            self.progressView.progress = self.progressView.progress + 0.002;
        }
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%.0f", self.progressView.progress * 100];

    int i = self.progressView.progress*10;
    if (status) {
        if (i == 0) {
            i = 1;
        }
        UIImageView *img = (UIImageView *)[self.view viewWithTag:i - 1 + 100];
        [img setImage:[UIImage imageNamed:@"broker_wlsj_nomen"]];
    }else{
        if (i == 0) {
            return;
        }
        UIImageView *img = (UIImageView *)[self.view viewWithTag:i - 1 + 100];
        [img setImage:[UIImage imageNamed:@"broker_wlsj_men"]];
    }
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
