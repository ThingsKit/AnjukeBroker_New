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
    UILabel *testLb = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, [self windowWidth] - 5*2, 30)];
    testLb.backgroundColor = [UIColor clearColor];
    testLb.textColor = SYSTEM_BLACK;
    testLb.font = [UIFont systemFontOfSize:20];
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
