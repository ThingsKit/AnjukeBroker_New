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
    UILabel *about = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, [self windowWidth] - 5*2, 250)];
    about.backgroundColor = [UIColor clearColor];
    about.numberOfLines = 0;
    about.lineBreakMode = NSLineBreakByWordWrapping;
    about.text = @"安居客集团 （Anjuke。Inc）成立于2007年1月的安居客集团是国内首选互联网房产信息服务商，旗下拥有专业二手房网站“安居客”，专业新房网站“爱房网”，专业租房网站“好租”和专业商业地产网站“金铺”，为各领域的不同用户提供“最佳找房体验”。同时，也为开发商、中介公司、经纪人、业主提供高效的网络推广平台。其在北京、上海、广州、深圳等超过30个城市均设有分公司。";
    about.textColor = SYSTEM_BLACK;
    about.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:about];
    
    //获取版本号
    UILabel *testLb = [[UILabel alloc] initWithFrame:CGRectMake(5, 300, [self windowWidth] - 5*2, 30)];
    testLb.backgroundColor = [UIColor clearColor];
    testLb.textColor = SYSTEM_BLACK;
    testLb.font = [UIFont systemFontOfSize:17];
    testLb.text = [self getAppVersion];
    [self.view addSubview:testLb];
    
    
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
