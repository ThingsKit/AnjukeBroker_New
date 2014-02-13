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
#import "AppDelegate.h"
#import "ConfigPlistManager.h"
#import "AccountManager.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIScrollView *mainSV;
@end

@implementation LoginViewController
@synthesize nameTF, passwordTF;
@synthesize mainSV;

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
    
    self.view.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    
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
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], [self windowHeight])];
    self.mainSV = sv;
    sv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sv];
    
    CGFloat btnW = 530/2;
    CGFloat btnGap = ([self windowWidth] - btnW)/2;
    CGFloat btnH = 85/2;
    
    CGFloat iconW = 140 /2;
    CGFloat iconGap = ([self windowWidth] -iconW)/2;
    
    CGFloat tfGap = 10;
    CGFloat tfGapH = 5;
    CGFloat tfW = btnW - tfGap*2;
    CGFloat tfH = btnH - tfGapH*2;
    
    UIColor *textBGColor = [Util_UI colorWithHexString:@"EFEFF4"];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_60.png"]];
    icon.frame = CGRectMake(iconGap, 70, iconW, iconW);
    icon.backgroundColor = [UIColor clearColor];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.layer.cornerRadius = 5;
    [sv addSubview:icon];
    
    UIView *BG1 = [[UIView alloc] initWithFrame:CGRectMake(btnGap, 150+ 10,  btnW, btnH)];
    BG1.backgroundColor = textBGColor;
    [sv addSubview:BG1];
    
    UITextField *cellTextField = nil;
    cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(tfGap, tfGapH, tfW, tfH)];
    cellTextField.returnKeyType = UIReturnKeyDone;
    cellTextField.backgroundColor = textBGColor;//[UIColor clearColor];
    cellTextField.borderStyle = UITextBorderStyleNone;
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cellTextField.text = @"";
    cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cellTextField.placeholder = @"手机号";
    cellTextField.delegate = self;
    cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cellTextField.font = [UIFont systemFontOfSize:17];
    cellTextField.textAlignment = NSTextAlignmentLeft;
    cellTextField.secureTextEntry = NO;
    cellTextField.textColor = SYSTEM_BLACK;
    self.nameTF = cellTextField;
    [BG1 addSubview:cellTextField];
    
    UIView *BG2 = [[UIView alloc] initWithFrame:CGRectMake(btnGap, BG1.frame.size.height+BG1.frame.origin.y+1,  btnW, btnH)];
    BG2.backgroundColor = textBGColor;
    [sv addSubview:BG2];
    
    UITextField *cellTextField2 = nil;
    cellTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(tfGap, tfGapH, tfW, tfH)];
    cellTextField2.returnKeyType = UIReturnKeyDone;
    cellTextField2.backgroundColor = textBGColor;//[UIColor clearColor];
    cellTextField2.borderStyle = UITextBorderStyleNone;
    cellTextField2.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cellTextField2.text = @"";
    cellTextField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    cellTextField2.placeholder = @"密  码";
    cellTextField2.delegate = self;
    cellTextField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cellTextField2.font = [UIFont systemFontOfSize:17];
    cellTextField2.textAlignment = NSTextAlignmentLeft;
    cellTextField2.secureTextEntry = YES;
    cellTextField2.textColor = SYSTEM_BLACK;
    self.passwordTF = cellTextField2;
    [BG2 addSubview:cellTextField2];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnGap, BG2.frame.origin.y + BG2.frame.size.height+ 20, btnW, btnH);
    [btn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_login_button.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3;
    [btn setTitle:@"登    录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doRequest) forControlEvents:UIControlEventTouchUpInside];
    [sv addSubview:btn];
    
    [self checkLoginStatus];
}

- (void)pushToTab {
    TabBarViewController *tb = [[TabBarViewController alloc] init];
    [[AppDelegate sharedAppDelegate] setTabController:tb];
    [self.navigationController pushViewController:tb animated:NO];
}

- (void)doLogOut { //清楚token，返回Home
    [LoginManager doLogout];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)checkLoginStatus {
//    [self pushToTab]; //test in Home
//    return;
    
    if ([LoginManager isLogin]) {
        [self pushToTab];
    }
}

- (void)changeScrollViewOffsetWithTF:(UITextField *)textField {
    [self.mainSV setFrame:CGRectMake(0, 0, [self windowWidth], [self windowHeight] -216)];
    
    CGFloat offsetY = 10;
    if ([self windowHeight] <= 960/2) {
        offsetY = 40;
    }
    CGFloat contentOffsetY = 0;
    
    if ([textField isEqual:self.nameTF]) {
        contentOffsetY = offsetY;
    }
    else if ([textField isEqual:self.passwordTF]) {
        contentOffsetY = offsetY*2;
    }
    
    [self.mainSV setContentOffset:CGPointMake(0, contentOffsetY) animated:NO];
}

- (void)changeScrollViewToNormal {
    [self.mainSV setFrame:CGRectMake(0, 0, [self windowWidth], [self windowHeight])];
    [self.mainSV setContentOffset:CGPointMake(0, 0) animated:NO];
}

#pragma mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self changeScrollViewOffsetWithTF:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doRequest];
    
    return YES;
}

#pragma mark - request method

- (void)doRequest {
    if (![self isNetworkOkay]) {
        return;
    }
    
    [self changeScrollViewToNormal];
    [self.nameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    
    NSString *s1 = self.nameTF.text; //@"ajk_sh";//@"18616099353";//@"shtest";
    NSString *s2 = self.passwordTF.text; //@"anjukeqa";//@"mobile123456";//@"anjukeqa";
    
    if (s1.length == 0) {
        [self showInfo:@"请输入用户名，谢谢!"];
        return;
    }
    else if (s2.length == 0) {
        [self showInfo:@"请输入密码!谢谢!"];
        return;
    }
    
    [self showLoadingActivity:YES];
    self.isLoading = YES;
    //test
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:s1, @"username", s2, @"password", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"login/" params:params target:self action:@selector(onGetLogin:)];
}

- (void)onGetLogin:(RTNetworkResponse *)response {

    DLog(@"------response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    
    if ([resultFromAPI count] == 0) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"登录信息出错" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDictionary *brokerDic = [[[response content] objectForKey:@"data"] objectForKey:@"broker"];
    
    //保存用户登录数据
    [[NSUserDefaults standardUserDefaults] setValue:[brokerDic objectForKey:@"id"] forKey:@"id"]; //用户id
    [[NSUserDefaults standardUserDefaults] setValue:[brokerDic objectForKey:@"username"] forKey:@"username"]; //用户登录名
    [[NSUserDefaults standardUserDefaults] setValue:[brokerDic objectForKey:@"use_photo"] forKey:@"userPhoto"]; //用户头像
    [[NSUserDefaults standardUserDefaults] setValue:[brokerDic objectForKey:@"city_id"] forKey:@"city_id"]; //city_id
    [[NSUserDefaults standardUserDefaults] setValue:[brokerDic objectForKey:@"phone"] forKey:@"phone"]; //联系电话
    [[NSUserDefaults standardUserDefaults] setValue:[brokerDic objectForKey:@"name"] forKey:@"name"]; //用户名
    
    [[NSUserDefaults standardUserDefaults] setValue:[resultFromAPI objectForKey:@"token"] forKey:@"token"]; //**token
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
    [self pushToTab];
    
    //每次重新登录请求配置数据
    [[AppDelegate sharedAppDelegate] requestSalePropertyConfig];
    [[AccountManager sharedInstance] registerNotification];
}

@end
