//
//  LoginViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-4.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "LoginViewController.h"
#import "Util_UI.h"
#import "TabBarViewController.h"
#import "LoginManager.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *passwordTF;
@end

@implementation LoginViewController
@synthesize nameTF, passwordTF;

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

- (void)dealloc {
    [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
- (void)initModel {
    
}

- (void)initDisplay {
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, [self windowWidth] - 100*2, 30)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor = SYSTEM_GREEN;
    titleLb.text = @"安  居  客";
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:titleLb];
    
    UITextField *cellTextField = nil;
    cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, titleLb.frame.origin.y + titleLb.frame.size.height+ 10,  [self windowWidth] - 20*2, 30)];
    cellTextField.returnKeyType = UIReturnKeyDone;
    cellTextField.backgroundColor = [UIColor clearColor];
    cellTextField.borderStyle = UITextBorderStyleNone;
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cellTextField.text = @"";
    cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cellTextField.placeholder = @"用户名";
    cellTextField.delegate = self;
    cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cellTextField.font = [UIFont systemFontOfSize:17];
    cellTextField.textAlignment = NSTextAlignmentLeft;
    cellTextField.secureTextEntry = NO;
    cellTextField.textColor = SYSTEM_BLACK;
    self.nameTF = cellTextField;
    [self.view addSubview:cellTextField];
    
    UITextField *cellTextField2 = nil;
    cellTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(20, self.nameTF.frame.origin.y + self.nameTF.frame.size.height+ 5,  [self windowWidth] - 20*2, 30)];
    cellTextField2.returnKeyType = UIReturnKeyDone;
    cellTextField2.backgroundColor = [UIColor clearColor];
    cellTextField2.borderStyle = UITextBorderStyleNone;
    cellTextField2.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cellTextField2.text = @"";
    cellTextField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    cellTextField2.placeholder = @"密  码";
    cellTextField2.delegate = self;
    cellTextField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cellTextField2.font = [UIFont systemFontOfSize:17];
    cellTextField2.textAlignment = NSTextAlignmentLeft;
    cellTextField2.secureTextEntry = NO;
    cellTextField2.textColor = SYSTEM_BLACK;
    self.passwordTF = cellTextField2;
    [self.view addSubview:cellTextField2];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, cellTextField2.frame.origin.y + cellTextField2.frame.size.height+ 20, [self windowWidth]- 50*2, 30);
    [btn setBackgroundColor:SYSTEM_BLUE];
    btn.layer.cornerRadius = 3;
    [btn setTitle:@"登    录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self checkLoginStatus];
}

- (void)pushToTab {
    TabBarViewController *tb = [[TabBarViewController alloc] init];
    [self.navigationController pushViewController:tb animated:NO];
}

- (void)checkLoginStatus {
//    [self pushToTab]; //test in Home
//    return;
    
    if ([LoginManager isLogin]) {
        [self pushToTab];
    }
}

#pragma mark - request method

- (void)doRequest {
    NSString *s1 = self.nameTF.text; //@"ajk_sh";//@"18616099353";//@"shtest";
    NSString *s2 = self.passwordTF.text; //@"anjukeqa";//@"mobile123456";//@"anjukeqa";
    
    if (s1.length == 0) {
        [self showInfo:@"请输入用户名好伐，谢谢"];
        return;
    }
    else if (s2.length == 0) {
        [self showInfo:@"请输入密码!谢谢你一家门!"];
        return;
    }
    
    [self showLoadingActivity:YES];
    
    //test
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:s1, @"username", s2, @"password", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"login/" params:params target:self action:@selector(onGetLogin:)];
}

- (void)onGetLogin:(RTNetworkResponse *)response {

    DLog(@"------response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        [self hideLoadWithAnimated:YES];
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    
    if ([resultFromAPI count] == 0) {
        [self hideLoadWithAnimated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"登录信息出错" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDictionary *brokerDic = [[[response content] objectForKey:@"data"] objectForKey:@"broker"];
    
    //保存用户登录数据
    [[NSUserDefaults standardUserDefaults] setValue:[brokerDic objectForKey:@"id"] forKey:@"id"]; //用户id
    [[NSUserDefaults standardUserDefaults] setValue:[brokerDic objectForKey:@"username"] forKey:@"username"]; //用户名
    [[NSUserDefaults standardUserDefaults] setValue:[brokerDic objectForKey:@"use_photo"] forKey:@"userPhoto"]; //用户头像
    [[NSUserDefaults standardUserDefaults] setValue:[brokerDic objectForKey:@"city_id"] forKey:@"city_id"]; //city_id
    [[NSUserDefaults standardUserDefaults] setValue:[resultFromAPI objectForKey:@"token"] forKey:@"token"]; //**token

    [self pushToTab];
    
    [self hideLoadWithAnimated:YES];
}

@end
