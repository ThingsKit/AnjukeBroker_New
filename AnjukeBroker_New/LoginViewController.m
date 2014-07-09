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
#import "BrokerRegisterViewController.h"
//RTGestureBackNavigationController
#import "RTGestureBackNavigationController.h"
#import "UIView+RTLayout.h"

#define IPHONE_5_HEIGHT  568
#define IPHONE_4S_HEIGHT 480


@interface LoginViewController ()

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic) UILabel *registerLabel;
@property (nonatomic) UIView  *textFieldViewTF;
@property (nonatomic) CGFloat logoW;
@property (nonatomic) CGFloat logoGap;
@property (nonatomic) CGFloat logoY;

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
    
    self.view.backgroundColor = [Util_UI colorWithHexString:@"EFEFF4"];
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
    
    [self checkLoginStatus];
    
    self.loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], [self windowHeight])];
    self.loginView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.loginView];
    
    UIView *statusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarBackground.backgroundColor = [Util_UI colorWithHexString:@"312A32"];

    if ([[UIDevice currentDevice].systemVersion compare:@"7.0"] >= 0) {
        [self.view addSubview:statusBarBackground];
    }
    self.logoW     = 95 ;
    self.logoGap   = ([self windowWidth] - self.logoW)/2;
    self.logoY     = 95;
    CGFloat btnW   = 530/2;
    CGFloat btnGap = ([self windowWidth] - btnW)/2;
    CGFloat btnH   = 85/2;
    
    CGFloat tfGap  = 10;
    CGFloat tfGapH = 5;
    CGFloat tfW    = btnW - tfGap*2;
    CGFloat tfH    = btnH - tfGapH*2;
    
    CGFloat textFieldViewTF_Y = 212 ;
    
    if (self.windowHeight != IPHONE_5_HEIGHT) {
        self.logoY = 60;
        textFieldViewTF_Y = self.logoY + 110;
    }
    
    self.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_60"]];
    self.logo.frame              = CGRectMake(self.logoGap, 140,  self.logoW,  self.logoW);
    self.logo.backgroundColor    = [UIColor clearColor];
    self.logo.contentMode        = UIViewContentModeScaleAspectFill;
    
    self.textFieldViewTF = [[UIView alloc] initWithFrame:CGRectMake(btnGap, textFieldViewTF_Y,  btnW, btnH*2+1)];
    self.textFieldViewTF.backgroundColor = [UIColor whiteColor];
    
    self.nameTF = [self textFieldWithFrame:CGRectMake(tfGap, tfGapH, tfW, tfH) PlaceHolder:@"手机号" secureTextEntry:NO];
    [self.textFieldViewTF addSubview:self.nameTF];
    
    UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(0, btnH, btnW, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    [self.textFieldViewTF addSubview:line];
    
    self.passwordTF = [self textFieldWithFrame:CGRectMake(tfGap, btnH+tfGapH+1, tfW, tfH) PlaceHolder:@"密码" secureTextEntry:YES];
    [self.textFieldViewTF addSubview:self.passwordTF];
    
    CGRect frame     = self.textFieldViewTF.frame;
    self.loginBtn    = [self loginBtnWithFrame:CGRectMake(btnGap, frame.origin.y + frame.size.height+ 20, btnW, btnH) title:@"登录" action:@selector(doRequest)];

    self.registerBtn = [self registerBtnWithFrame:CGRectMake(115,self.view.bottom - 85, 90, 33) title:@"注册" action:@selector(doRegister)];
    self.registerLabel  = [[UILabel alloc] initWithFrame:CGRectMake(103, self.view.bottom - 118 , 140, 20)];

    self.registerLabel.text      = @"房源客户，一网打尽";
    self.registerLabel.textColor = [UIColor brokerLightGrayColor];
    self.registerLabel.font      = [UIFont systemFontOfSize:14];
    self.registerLabel.backgroundColor = [UIColor clearColor];
    
    [self.loginView addSubview:self.textFieldViewTF];
    [self.loginView addSubview:self.logo];
    [self.loginView addSubview:self.loginBtn];
    [self.loginView addSubview:self.registerBtn];
    [self.loginView addSubview:self.registerLabel];
    
#ifdef DEBUG
    //###########################################################
    //定义长按自动填充手势
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(autoSetUserNameAndPassword:)];
    longPressGesture.minimumPressDuration = 1;
    [self.loginBtn addGestureRecognizer:longPressGesture];
    //###########################################################
#endif
    

#ifdef DEBUG
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 20, 320, 40);
    [btn addTarget:self action:@selector(hit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
#else
#endif

    
    [self viewLoadAnimation];
}

- (void)hit:(id)sender{
    self.nameTF.text = @"13681983677";
    self.passwordTF.text = @"anjukeqa";

    [self viewLoadAnimation];
}

#pragma mark -
#pragma mark 长按登录按钮自动填充用户名和密码 add by leo

#ifdef DEBUG
- (void)autoSetUserNameAndPassword:(UILongPressGestureRecognizer*)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按自动填充");
        self.nameTF.text = @"ajk_sh";
        self.passwordTF.text = @"123456";
    }
}
#endif

// 创建loginBtn 对象
- (UIButton *)loginBtnWithFrame:(CGRect)frame title:(NSString*)title action:(SEL)action
{
    UIButton *loginBtn = [self buttonWithFrame:frame title:title action:action];
    [loginBtn  setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_login_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateNormal];
    [loginBtn  setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_login_button_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateHighlighted];
    return loginBtn;
}

// 创建registerBtn 对象
- (UIButton *)registerBtnWithFrame:(CGRect)frame title:(NSString*)title action:(SEL)action
{
    UIColor *registerBtnColor      = [UIColor brokerBabyBlueColor];
    UIButton *registerBtn          = [self buttonWithFrame:frame title:title action:action];
    registerBtn.titleLabel.font    = [UIFont systemFontOfSize:17];
    [registerBtn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_little_blue_hollow"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [registerBtn setTitleColor:registerBtnColor forState:UIControlStateNormal];
    
    return registerBtn;
}

// 在view加载完后，显示动画
- (void)viewLoadAnimation
{
    
    CGFloat logoGap = ([self windowWidth] - self.logoW)/2;
    self.logo.frame = CGRectMake(logoGap, 140,  self.logoW,  self.logoW);
    self.logo.alpha = 0.5;
    
    self.textFieldViewTF.alpha = 0.0;
    self.loginBtn.alpha        = 0.0;
    self.registerBtn.alpha     = 0.0;
    self.registerLabel.alpha   = 0.0;
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.logo.frame = CGRectMake(logoGap, self.logoY,  self.logoW,  self.logoW);
        self.logo.alpha = 1.0;
        self.textFieldViewTF.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.8 delay:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.textFieldViewTF.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.8 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.loginBtn.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.8 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
        self.registerBtn.alpha   = 1.0;
        self.registerLabel.alpha = 1.0;
    }completion:^(BOOL finished){
        
    }];

}

//生成Login界面中统一的UIButton
- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action
{
    UIButton *button          = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame              = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
    
}


//生成Login界面中统一的textField
- (UITextField *)textFieldWithFrame:(CGRect)frame PlaceHolder:(NSString *)placeHolder secureTextEntry:(BOOL)secureTextEntry
{
    UITextField * textField = [[UITextField alloc] initWithFrame:frame];
    
    textField.returnKeyType = UIReturnKeyDone;
    textField.backgroundColor = [UIColor clearColor];
    textField.borderStyle = UITextBorderStyleNone;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.text = @"";
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = placeHolder;
    textField.delegate = self;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.font = [UIFont systemFontOfSize:17];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.secureTextEntry = secureTextEntry;
    textField.textColor = SYSTEM_BLACK;
    
    return textField;
}

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

- (void)doRegister {
    RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:[BrokerRegisterViewController new]];
    [self presentModalViewController:nav animated:YES];
}

#pragma mark - request method

- (void)doRequest {
    [[BrokerLogger sharedInstance] logWithActionCode:LOGIN_CLICK_LOGIN page:LOGIN note:nil];
    
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
    
    //获得城市商业模式
    [[AppDelegate sharedAppDelegate] getBuinessType];
    
    [self pushToTab];
    
    //每次重新登录请求配置数据
    [[AppDelegate sharedAppDelegate] requestSalePropertyConfig];
    [[AccountManager sharedInstance] registerNotification];
}

@end
