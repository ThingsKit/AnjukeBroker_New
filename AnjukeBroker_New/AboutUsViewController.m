//
//  AboutUsViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-19.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AboutUsViewController.h"
#import "Util_UI.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

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
    
    [self setTitleViewWithString:@"关于我们"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)initModel {
    
}

- (void)initDisplay {
    UILabel *about = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, [self windowWidth] - 5*2, 230)];
    about.backgroundColor = [UIColor clearColor];
    about.numberOfLines = 0;
    about.lineBreakMode = NSLineBreakByWordWrapping;
    about.text = @"安居客是国内优质房地产租售服务平台，专注于房地产租售信息服务。安居客以“帮助人们实现家的梦想”为企业愿景，全面覆盖买房、租房、商业地产三大业务，同时为开发商与经纪人提供高效的网络推广平台。安居客旗下业务网站每月独立访问用户已突破6600万。移动经纪人致力于更好的为经纪人服务，满足经纪人需求，打造经纪人的移动工作平台。";
    about.textColor = SYSTEM_BLACK;
    about.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:about];
    
    //获取版本号
    UILabel *testLb = [[UILabel alloc] initWithFrame:CGRectMake(5, 300, [self windowWidth] - 5*2, 30)];
    testLb.backgroundColor = [UIColor clearColor];
    testLb.textColor = SYSTEM_BLACK;
    testLb.font = [UIFont systemFontOfSize:16];
    testLb.text = [self getAppVersion];
    [self.view addSubview:testLb];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_KEY_DEVICE_TOKEN];
    if (token.length > 0 && ![token isKindOfClass:[NSNull class]]) {
        UILabel *deviceTokenLb = [[UILabel alloc] initWithFrame:CGRectMake(5, 330+3, [self windowWidth] - 5*2, 80)];
        deviceTokenLb.backgroundColor = [UIColor clearColor];
        deviceTokenLb.textColor = SYSTEM_BLACK;
        deviceTokenLb.font = [UIFont systemFontOfSize:16];
        deviceTokenLb.numberOfLines = 0;
        deviceTokenLb.text = [NSString stringWithFormat:@"deviceToken: %@", token];
        [self.view addSubview:deviceTokenLb];
    }
}

- (NSString *)getAppVersion {
    NSString *strVer = [NSString string];
    
    NSString *current_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *device_info = [[RTLogger sharedInstance] channelID];
    NSString *umeng_key = [[[RTLogger sharedInstance] appKey] substringFromIndex:18];
    strVer = [NSString stringWithFormat:@"%@ %@ %@",current_version,device_info,umeng_key];

    return strVer;
}

@end
