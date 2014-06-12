//
//  WXDataShowViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "WXDataShowViewController.h"

@interface WXDataShowViewController ()

@end

@implementation WXDataShowViewController
@synthesize progressView;
@synthesize totalCustomer;
@synthesize totalResponseTime;
@synthesize userCenterModel;
@synthesize timer;
@synthesize numberLabel;

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
    // Do any additional setup after loading the view.
    [self setTitleViewWithString:@"微聊数据"];
    [self initUI];
    [self doRequest];
}

- (void)initUI{
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, [self windowWidth], 14)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.text = @"5分钟内回复客户数占比";
    titLab.font = [UIFont ajkH4Font];
    titLab.textColor = [UIColor brokerMiddleGrayColor];
    titLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titLab];
    
    self.progressView = [[PICircularProgressView alloc] initWithFrame:CGRectMake(45, 70, 230, 230)];
    self.progressView.progress = 0.0;
    self.progressView.thicknessRatio = 0.15;
    self.progressView.showShadow = NO;
    self.progressView.innerBackgroundColor = [UIColor whiteColor];
    self.progressView.outerBackgroundColor = [UIColor brokerLineColor];
    self.progressView.showText = NO;
    self.progressView.roundedHead = YES;
    self.progressView.progressTopGradientColor = [UIColor brokerBabyBlueColor];
    [self.view addSubview:self.progressView];
    
    for (int i = 0; i < 10; i++) {
        int j = i / 5;
        int k = i % 5;
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.tag = 100 + i;
        imgView.frame = CGRectMake(97 + k * 28, 160 + j * 45, 14, 35);
        [imgView setImage:[UIImage imageNamed:@"broker_wlsj_nomen"]];
        [self.view addSubview:imgView];
    }
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 60, 50)];
    self.numberLabel.font = [UIFont systemFontOfSize:50];
    self.numberLabel.textColor = [UIColor brokerMiddleGrayColor];
    self.numberLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.numberLabel];
    
    UILabel *unitLab = [[UILabel alloc] initWithFrame:CGRectMake(self.numberLabel.frame.origin.x + self.numberLabel.frame.size.width + 5, self.numberLabel.frame.origin.y + 25, 20, 20)];
    unitLab.text = @"%";
    unitLab.font = [UIFont ajkH4Font];
    unitLab.textColor = [UIColor brokerMiddleGrayColor];
    [self.view addSubview:unitLab];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 340, [self windowWidth], 200)];
    footView.backgroundColor = [UIColor brokerBgPageColor];
    [self.view addSubview:footView];
    
    UILabel *detail1Lab = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 100, 15)];
    detail1Lab.text = @"累积客户数(个)";
    detail1Lab.textAlignment = NSTextAlignmentCenter;
    detail1Lab.textColor = [UIColor brokerLightGrayColor];
    detail1Lab.backgroundColor = [UIColor clearColor];
    detail1Lab.font = [UIFont ajkH4Font];
    [footView addSubview:detail1Lab];

    UILabel *detail2Lab = [[UILabel alloc] initWithFrame:CGRectMake(160, 20, 120, 15)];
    detail2Lab.text = @"平均响应时长(分钟)";
    detail2Lab.textAlignment = NSTextAlignmentCenter;
    detail2Lab.textColor = [UIColor brokerLightGrayColor];
    detail2Lab.backgroundColor = [UIColor clearColor];
    detail2Lab.font = [UIFont ajkH4Font];
    [footView addSubview:detail2Lab];
    
    self.totalCustomer = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 100, 25)];
    self.totalCustomer.textColor = [UIColor brokerMiddleGrayColor];
    self.totalCustomer.font = [UIFont systemFontOfSize:25];
    self.totalCustomer.backgroundColor = [UIColor clearColor];
    self.totalCustomer.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:self.totalCustomer];

    self.totalResponseTime = [[UILabel alloc] initWithFrame:CGRectMake(160, 50, 120, 25)];
    self.totalResponseTime.textColor = [UIColor brokerMiddleGrayColor];
    self.totalResponseTime.font = [UIFont systemFontOfSize:25];
    self.totalResponseTime.backgroundColor = [UIColor clearColor];
    self.totalResponseTime.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:self.totalResponseTime];

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
            self.progressView.progress = self.progressView.progress - 0.006;
        }else{
            self.progressView.progress = self.progressView.progress + 0.006;
        }
    }else if (progress > 0.6){
        if (status) {
            self.progressView.progress = self.progressView.progress - 0.010;
        }else{
            self.progressView.progress = self.progressView.progress + 0.010;
        }
    }else if (progress > 0.2){
        if (status) {
            self.progressView.progress = self.progressView.progress - 0.008;
        }else{
            self.progressView.progress = self.progressView.progress + 0.008;
        }
    }else{
        if (status) {
            self.progressView.progress = self.progressView.progress - 0.004;
        }else{
            self.progressView.progress = self.progressView.progress + 0.004;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
