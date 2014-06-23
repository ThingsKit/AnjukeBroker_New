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
@property (nonatomic, strong) UIView *loginView;
@end

@implementation LoginViewController
@synthesize nameTF, passwordTF;
@synthesize loginView;

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

//#pragma mark - log
//
//- (void)sendAppearLog {
//}
//- (void) sendDisAppearLog
//{
//    [[BrokerLogger sharedInstance] logWithActionCode:APP_LOGIN_004 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
//}

#pragma mark - private method
- (void)initModel {
    
}

- (void)initDisplay {
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
    
    [self checkLoginStatus];
    
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], [self windowHeight])];
    lv.backgroundColor = [UIColor clearColor];
    self.loginView = lv;
    [self.view addSubview:self.loginView];
    
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
    icon.backgroundColor = [UIColor clearColor];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.layer.cornerRadius = 5;
    [lv addSubview:icon];
    
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(btnGap, 150+ 10,  btnW, btnH*2+1)];
    textFieldView.backgroundColor = textBGColor;
    [lv addSubview:textFieldView];
    
    UITextField *cellTextField = nil;
    cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(tfGap, tfGapH, tfW, tfH)];
    cellTextField.returnKeyType = UIReturnKeyDone;
    cellTextField.backgroundColor = [UIColor clearColor];
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
    [textFieldView addSubview:cellTextField];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, btnH, btnW, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    [textFieldView addSubview:line];
    
    UITextField *cellTextField2 = nil;
    cellTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(tfGap, btnH+tfGapH+1, tfW, tfH)];
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
    cellTextField2.secureTextEntry = YES;
    cellTextField2.textColor = SYSTEM_BLACK;
    self.passwordTF = cellTextField2;
    [textFieldView addSubview:cellTextField2];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnGap, textFieldView.frame.origin.y + textFieldView.frame.size.height+ 20, btnW, btnH);
    [btn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_login_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_login_button_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateHighlighted];
    btn.layer.cornerRadius = 3;
    [btn setTitle:@"登    录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doRequest) forControlEvents:UIControlEventTouchUpInside];
    [lv addSubview:btn];
    
#ifdef DEBUG
    //###########################################################
    //定义长按自动填充手势
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(autoSetUserNameAndPassword:)];
    longPressGesture.minimumPressDuration = 1;
    [btn addGestureRecognizer:longPressGesture];
    //###########################################################
#endif
    
    
    icon.frame = CGRectMake(iconGap, 70+70, iconW, iconW);
    icon.alpha = 0.5;
    
    textFieldView.alpha = 0.0;
    btn.alpha = 0.0;
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        icon.frame = CGRectMake(iconGap, 70, iconW, iconW);
        icon.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.8 delay:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        textFieldView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.8 delay:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        btn.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark -
#pragma mark 长按登录按钮自动填充用户名和密码 add by leo

#ifdef DEBUG
- (void)autoSetUserNameAndPassword:(UILongPressGestureRecognizer*)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按自动填充");
        self.nameTF.text = @"ajk_nj";
        self.passwordTF.text = @"anjukeqa";
    }
}
#endif



- (void)pushToTab {
    [[BrokerLogger sharedInstance] logWithActionCode:LOGIN_SUCCESS page:LOGIN note:nil];

    self.nameTF.text = @"";
    self.passwordTF.text = @"";
    
    TabBarViewController *tb = [[TabBarViewController alloc] init];
    [[AppDelegate sharedAppDelegate] setTabController:tb];
    [self.navigationController pushViewController:tb animated:NO];
}

- (void)doLogOut { //清除token，返回Home
    [LoginManager doLogout];
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)checkLoginStatus {
    if ([LoginManager isLogin]) {
        [self pushToTab];
    }else{
        [[BrokerLogger sharedInstance] logWithActionCode:LOGIN_ONVIEW page:LOGIN note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    }
}

- (void)changeScrollViewOffsetWithTF:(UITextField *)textField {
    CGFloat offsetY = 10;
    if ([self windowHeight] <= 960/2) {
        offsetY = 80;
    }

    if (self.loginView.frame.origin.y == -offsetY) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.loginView.frame;
        frame.origin.y = -offsetY;
        self.loginView.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

- (void)changeScrollViewToNormal {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(0, 0, [self windowWidth], [self windowHeight]);
        self.loginView.frame = frame;
    } completion:^(BOOL finished) {
    }];
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
    [[BrokerLogger sharedInstance] logWithActionCode:LOGIN_CLICK_LOGIN page:LOGIN_CLICK_LOGIN note:nil];

    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESSNOTIFICATION" object:nil];
    NSDictionary *brokerDic = [[[response content] objectForKey:@"data"] objectForKey:@"broker"];
    DLog(@"resultFromAPI-->>%@",resultFromAPI);
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
