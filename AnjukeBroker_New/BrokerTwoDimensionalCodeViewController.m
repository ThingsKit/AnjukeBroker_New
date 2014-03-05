//
//  BrokerTwoDimensionalCodeViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-23.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BrokerTwoDimensionalCodeViewController.h"
#import "Util_UI.h"
#import "WebImageView.h"
#import "LoginManager.h"

@interface BrokerTwoDimensionalCodeViewController ()

@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *remarkLb;
@property (nonatomic, strong) WebImageView *brokerIcon;
@property (nonatomic, strong) WebImageView *brokerGigImg;

@end

@implementation BrokerTwoDimensionalCodeViewController
@synthesize nameLb, remarkLb;
@synthesize brokerIcon;

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
    
    [self setTitleViewWithString:@"我的二维码"];
    self.view.backgroundColor = SYSTEM_LIGHT_GRAY_BG2;
    
    [self setValueForShow];
    [self doRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method

- (void)initModel {
    
}

- (void)initDisplay {
    WebImageView *icon = [[WebImageView alloc] initWithFrame:CGRectMake(40, 35, 40, 40)];
    icon.backgroundColor = [UIColor clearColor];
    icon.layer.borderWidth = 0.5;
    icon.layer.borderColor = SYSTEM_BLACK.CGColor;
    icon.layer.cornerRadius = 5;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.imageUrl = [LoginManager getUse_photo_url];
    [self.view addSubview:icon];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 15, icon.frame.origin.y, 200, 20)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont boldSystemFontOfSize:15];
    titleLb.textColor = SYSTEM_BLACK;
    self.nameLb = titleLb;
    [self.view addSubview:titleLb];
    
    UILabel *titleLb2 = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 15, titleLb.frame.origin.y+ titleLb.frame.size.height + 5, 200, 20)];
    titleLb2.backgroundColor = [UIColor clearColor];
    titleLb2.font = [UIFont boldSystemFontOfSize:12];
    titleLb2.textColor = SYSTEM_BLACK;
    self.remarkLb = titleLb2;
    [self.view addSubview:titleLb2];

    CGFloat bgW = 240;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(icon.frame.origin.x, icon.frame.origin.y + icon.frame.size.height + 30, bgW, bgW)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bgView.layer.borderWidth = 1;
    [self.view addSubview:bgView];
    
    CGFloat imgW = 290/2;
    self.brokerGigImg = [[WebImageView alloc] initWithFrame:CGRectMake((bgW - imgW)/2, (bgW - imgW)/2 - 10, imgW, imgW)];
    self.brokerGigImg.backgroundColor = [UIColor clearColor];
    self.brokerGigImg.imageUrl = [LoginManager getTwoCodeIcon];
    [bgView addSubview:self.brokerGigImg];
    
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(0, self.brokerGigImg.frame.origin.y + imgW + 20, bgW, 20)];
    tips.backgroundColor = [UIColor clearColor];
    tips.font = [UIFont systemFontOfSize:12];
    tips.textColor = SYSTEM_LIGHT_GRAY;
    tips.textAlignment = NSTextAlignmentCenter;
    tips.text = @"扫一扫上面的二维码，加我微聊";
    [bgView addSubview:tips];
}

- (void)setValueForShow {
    self.nameLb.text = [LoginManager getRealName];
//    self.remarkLb.text = @"我爱我家联洋店";
}

#pragma mark - Request Method

- (void)doRequest {
    if (![self isNetworkOkay]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",[LoginManager getCity_id], @"cityId", nil];
    method = @"broker/getinfo/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onRequestFinished:(RTNetworkResponse *)response {
    DLog(@"。。。response [%@]", [response content]);
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    NSDictionary *dic = [[[response content] objectForKey:@"data"] objectForKey:@"brokerInfo"];
    self.remarkLb.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"store"]];
    //
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

@end
