//
//  AboutUsViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-19.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AboutUsViewController.h"
#import "Util_UI.h"
#import "BK_RTNavigationController.h"
#import "AppTestModeSettingViewController.h"

#define UMENG_KEY_OFFLINE @"529da42356240b93f001f9b4"
#define UMENG_KEY_ONLINE @"52a0368c56240ba07800b4c0"

@interface AboutUsViewController ()

@property (nonatomic, assign) NSInteger count;

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
    UIButton* hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hiddenButton.frame = CGRectMake(0, 0, 50, 50);
//    hiddenButton.backgroundColor = [UIColor redColor];
    [hiddenButton addTarget:self action:@selector(onButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hiddenButton];
    self.count = 0;
    
    [self setTitleViewWithString:@"关于我们"];
}

#pragma mark -
#pragma mark onButtonClickAction
- (void)onButtonClickAction:(UIButton*)button{
    self.count++;
    
    if (self.count > 4) {
        AppTestModeSettingViewController * testVC = [[AppTestModeSettingViewController alloc] init];
        testVC.backType = RTSelectorBackTypeDismiss;
        BK_RTNavigationController * nav = [[BK_RTNavigationController alloc] initWithRootViewController:testVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
        self.count = 0;
    }
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
    float originY = 30;
    if ([self windowHeight] < 568) {
        originY = 20;
    }
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(68, originY, 140, 100)];
    [icon setImage:[UIImage imageNamed:@"anjuke_icon_login"]];
    [self.view addSubview:icon];

    UILabel *broker = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.frame.origin.y + icon.frame.size.height + 10, [self windowWidth], 20)];
    broker.font = [UIFont systemFontOfSize:18];
    broker.textAlignment = NSTextAlignmentCenter;
    broker.text = @"移动经纪人";
    [self.view addSubview:broker];
    
    //获取版本号
    UILabel *testLb = [[UILabel alloc] initWithFrame:CGRectMake(5, broker.frame.origin.y+broker.frame.size.height, [self windowWidth], 20)];
    testLb.backgroundColor = [UIColor clearColor];
    testLb.textColor = SYSTEM_BLACK;
    testLb.textAlignment = NSTextAlignmentCenter;
    testLb.font = [UIFont systemFontOfSize:14];
    testLb.text = [self getAppVersion];
    [self.view addSubview:testLb];

    
    UILabel *about = [[UILabel alloc] initWithFrame:CGRectMake(10, testLb.frame.origin.y+testLb.frame.size.height, [self windowWidth] - 10*2, 230)];
    about.backgroundColor = [UIColor clearColor];
    about.numberOfLines = 0;
    about.lineBreakMode = NSLineBreakByWordWrapping;
    about.text = @"   安居客是国内优质房地产租售服务平台，专注于房地产租售信息服务。安居客以“帮助人们实现家的梦想”为企业愿景，全面覆盖买房、租房、商业地产三大业务，同时为开发商与经纪人提供高效的网络推广平台。安居客旗下业务网站每月独立访问用户已突破6600万。移动经纪人致力于更好的为经纪人服务，满足经纪人需求，打造经纪人的移动工作平台。";
    about.textColor = SYSTEM_BLACK;
    about.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:about];
    
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(0, 0, [self windowWidth], 30);
    checkBtn.backgroundColor = [UIColor clearColor];
    [checkBtn addTarget:self action:@selector(doCheck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBtn];
}

- (NSString *)getAppVersion {
    NSString *strVer = [NSString string];
    
    NSString *current_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *device_info = [[RTLogger sharedInstance] channelID];
    
    NSString *umeng_key = nil;
    
#ifdef DEBUG
    umeng_key = [NSString stringWithFormat:@"%@",UMENG_KEY_OFFLINE];
#else
    umeng_key = [NSString stringWithFormat:@"%@",UMENG_KEY_ONLINE];
#endif
    
    strVer = [NSString stringWithFormat:@"当前版本：%@ %@ %@",current_version,device_info,umeng_key];
    
    return strVer;
}

- (void)doCheck {
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_KEY_DEVICE_TOKEN];
    if (token.length > 0 && ![token isKindOfClass:[NSNull class]]) {
        UILabel *deviceTokenLb = [[UILabel alloc] initWithFrame:CGRectMake(5, [self windowHeight] - 80 -64, [self windowWidth] - 5*2, 80)];
        deviceTokenLb.backgroundColor = [UIColor clearColor];
        deviceTokenLb.textColor = SYSTEM_BLACK;
        deviceTokenLb.font = [UIFont systemFontOfSize:16];
        deviceTokenLb.numberOfLines = 0;
        deviceTokenLb.text = [NSString stringWithFormat:@"deviceToken: %@", token];
        [self.view addSubview:deviceTokenLb];
    }
}

@end
