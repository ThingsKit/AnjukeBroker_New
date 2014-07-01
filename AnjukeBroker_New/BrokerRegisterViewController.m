//
//  BrokerRegisterViewController.m
//  AnjukeBroker_New
//
//  Created by wyf on 6/24/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "BrokerRegisterViewController.h"
#import <RTLineView.h>
#import "BrokerRegisterInfoViewController.h"

@interface BrokerRegisterViewController ()

@property (nonatomic, strong) UIButton *verifyBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *verifyTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, assign) int secondsCountDown;
@property (nonatomic,strong) NSTimer *countDownTimer;

@end

@implementation BrokerRegisterViewController

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
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    UIFont *lblFont = [UIFont systemFontOfSize:15];
    
    RTLineView *topLineView = [[RTLineView alloc] initWithFrame:CGRectMake(0, 20, 320, 1)];
    UILabel *phoneLbl = [UILabel new];
    phoneLbl.frame = CGRectMake(15, topLineView.bottom, 65, 44);
    phoneLbl.font = lblFont;
    phoneLbl.text = @"手机号";
    
    UITextField *phoneTextField = [UITextField new];
    phoneTextField.frame = CGRectMake(82, topLineView.bottom, 200, 44);
    phoneTextField.borderStyle = UITextBorderStyleNone;
    phoneTextField.font = lblFont;
    phoneTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    RTLineView *verticalLineView = [[RTLineView alloc] initWithFrame:CGRectMake(225, topLineView.bottom, 1, 44)];
    verticalLineView.horizontalLine = NO;
    
    
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verifyBtn.frame = CGRectMake(225, topLineView.bottom, 95, 44);
    verifyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verifyBtn setTitleColor:[UIColor colorWithHex:0x375aa2 alpha:1.0] forState:UIControlStateNormal];
    [verifyBtn addTarget:self action:@selector(requestVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    
    RTLineView *phoneLineView = [[RTLineView alloc] initWithFrame:CGRectMake(15, topLineView.bottom+45, 305, 1)];
    
    UILabel *verifyLbl = [UILabel new];
    verifyLbl.frame = CGRectMake(15, phoneLineView.bottom, 65, 44);
    verifyLbl.font = lblFont;
    verifyLbl.text = @"验证码";
    
    UITextField *verifyTextField = [UITextField new];
    verifyTextField.frame = CGRectMake(82, phoneLineView.bottom, 200, 44);
    verifyTextField.borderStyle = UITextBorderStyleNone;
    verifyTextField.font = lblFont;
    verifyTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    RTLineView *verifyLineView = [[RTLineView alloc] initWithFrame:CGRectMake(15, phoneLineView.bottom+45, 305, 1)];
    
    UILabel *passwordLbl = [UILabel new];
    passwordLbl.frame = CGRectMake(15, verifyLineView.bottom, 65, 44);
    passwordLbl.font = lblFont;
    passwordLbl.text = @"密码";
    
    UITextField *passwordTextField = [UITextField new];
    passwordTextField.frame = CGRectMake(82, verifyLineView.bottom, 200, 44);
    passwordTextField.borderStyle = UITextBorderStyleNone;
    passwordTextField.font = lblFont;
    passwordTextField.secureTextEntry = YES;
    
    RTLineView *bottomLineView = [[RTLineView alloc] initWithFrame:CGRectMake(0, verifyLineView.bottom+45, 320, 1)];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(15, bottomLineView.bottom+20, 290, 40);
    [nextBtn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_login_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_login_button_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateHighlighted];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:topLineView];
    [self.view addSubview:phoneLbl];
    [self.view addSubview:phoneTextField];
    [self.view addSubview:verticalLineView];
    [self.view addSubview:verifyBtn];
    [self.view addSubview:phoneLineView];
    [self.view addSubview:verifyLbl];
    [self.view addSubview:verifyTextField];
    [self.view addSubview:verifyLineView];
    [self.view addSubview:passwordLbl];
    [self.view addSubview:passwordTextField];
    [self.view addSubview:bottomLineView];
    [self.view addSubview:nextBtn];
    
    self.phoneTextField = phoneTextField;
    self.verifyTextField = verifyTextField;
    self.verifyBtn = verifyBtn;
    self.passwordTextField = passwordTextField;
    self.nextBtn = nextBtn;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTitleViewWithString:@"注册"];
}

- (void)doBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - validate the imput mobile phone number
- (BOOL)stringIsNumber:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if ([string isEqualToString:filtered]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)validatePhoneNum:(NSString*) phoneNum
{
    if(!([phoneNum length] == 11 && [self stringIsNumber:phoneNum])){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"手机号码错误"
                                                           message:@"你输入的一个无效的手机号码"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (BOOL)validateVerifyCode:(NSString*) verifyCode
{
    if(!verifyCode || verifyCode.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入验证码"
                                                           message:@"请输入验证码"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (BOOL)validatePassword:(NSString*) password
{
    NSString *regrex = @"[A-Z0-9a-z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regrex];
    BOOL valid = [predicate evaluateWithObject:password];
    
    if ([password length] < 6 || [password length] > 16 || !valid) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"密码格式错误"
                                                           message:@"密码长度为6～16位，仅限数字和字母"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (void)requestVerifyCode {
    if (![self validatePhoneNum:self.phoneTextField.text]) {
        return;
    }
    [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:@"common/captcha/sms/" params:@{@"mobile":self.phoneTextField.text,@"is_nocheck":@"1"} target:self action:@selector(onReceiveVerifyCode:)];
    
    self.secondsCountDown = 5;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(timeFireMethod)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)onReceiveVerifyCode:(RTNetworkResponse *)response {
    DLog(@"response [%@]", [response content]);
}


- (void)timeFireMethod{
    self.secondsCountDown--;
    [self.verifyBtn setEnabled:NO];
    [self.verifyBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",self.secondsCountDown] forState:UIControlStateDisabled];
    [self.verifyBtn setTitleColor:[UIColor colorWithHex:0x8d8c92 alpha:1.0f] forState:UIControlStateDisabled];
    
    if(self.secondsCountDown == 0){
        [self.countDownTimer invalidate];
        [self.verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.verifyBtn setTitleColor:[UIColor colorWithHex:0x375aa2 alpha:1.0] forState:UIControlStateNormal];
        [self.verifyBtn setEnabled:YES];
    }
}

- (void)nextAction {
    BrokerRegisterInfoViewController *controller = [BrokerRegisterInfoViewController new];
    if (self.phoneTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        controller.beforeDic = @{@"mobile":self.phoneTextField.text, @"password":self.passwordTextField.text};
    }
    
    [self.navigationController pushViewController:controller animated:YES];
    return;
    
    if (![self validatePhoneNum:self.phoneTextField.text] || ![self validateVerifyCode:self.verifyTextField.text] || ![self validatePassword:self.passwordTextField.text]) {
        return;
    }
    
    [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:@"common/captcha/verify/" params:@{@"mobile":self.phoneTextField.text,@"authCode":self.verifyTextField.text,@"is_nocheck":@"1"} target:self action:@selector(onCheckVerifyCode:)];
    
    [self showLoadingActivity:YES];
}

- (void)onCheckVerifyCode:(RTNetworkResponse *)response {
    DLog(@"response [%@]", [response content]);
    
    [self hideLoadWithAnimated:YES];
    if (response.content && [response.content[@"status"] isEqualToString:@"ok"] && response.content[@"data"]) {
        NSDictionary *dic = response.content[@"data"];
        if ([dic[@"checkStatus"] isEqualToString:@"true"]) {
            BrokerRegisterInfoViewController *controller = [BrokerRegisterInfoViewController new];
            controller.beforeDic = @{@"mobile":self.phoneTextField.text, @"password":self.passwordTextField.text};
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)dealloc
{
    [self.countDownTimer invalidate];
    self.secondsCountDown = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
