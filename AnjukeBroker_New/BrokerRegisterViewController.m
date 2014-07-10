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
#import "BrokerCallAlert.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "BrokerLineView.h"
#import "HudTipsUtils.h"

@interface BrokerRegisterViewController ()<UIScrollViewDelegate, UITextFieldDelegate>

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
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.height)];
    scrollView.delegate = self;
    
    CGSize newSize = CGSizeMake(320, self.view.height);
    
    [scrollView setContentSize:newSize];
    
    
    UIFont *lblFont = [UIFont ajkH2Font];
    UIColor *lblColor = [UIColor brokerMiddleGrayColor];
    UIColor *textFieldColor = [UIColor brokerBlackColor];
    
    RTLineView *topLineView = [[RTLineView alloc] initWithFrame:CGRectMake(0, 20, 320, 1)];
    UILabel *phoneLbl = [UILabel new];
    phoneLbl.frame = CGRectMake(15, topLineView.bottom, 65, 44);
    phoneLbl.font = lblFont;
    phoneLbl.textColor = lblColor;
    phoneLbl.text = @"手机号";
    
    UITextField *phoneTextField = [UITextField new];
    phoneTextField.frame = CGRectMake(82, topLineView.bottom, 150, 44);
    phoneTextField.borderStyle = UITextBorderStyleNone;
    phoneTextField.font = lblFont;
    phoneTextField.keyboardType =UIKeyboardTypeNumberPad;
    phoneTextField.textColor = textFieldColor;
    phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTextField.placeholder = @"11位手机号";
    phoneTextField.delegate = self;
    
    RTLineView *verticalLineView = [[RTLineView alloc] initWithFrame:CGRectMake(225, topLineView.bottom, 1, 44)];
    verticalLineView.horizontalLine = NO;
    
    
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verifyBtn.frame = CGRectMake(225, topLineView.bottom, 95, 44);
    verifyBtn.titleLabel.font = [UIFont ajkH4Font];
    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verifyBtn setTitleColor:[UIColor brokerBabyBlueColor] forState:UIControlStateNormal];
    [verifyBtn addTarget:self action:@selector(requestVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    
    RTLineView *phoneLineView = [[RTLineView alloc] initWithFrame:CGRectMake(15, topLineView.bottom+45, 305, 1)];
    
    UILabel *verifyLbl = [UILabel new];
    verifyLbl.frame = CGRectMake(15, phoneLineView.bottom, 65, 44);
    verifyLbl.font = lblFont;
    verifyLbl.text = @"验证码";
    verifyLbl.textColor = lblColor;
    
    UITextField *verifyTextField = [UITextField new];
    verifyTextField.frame = CGRectMake(82, phoneLineView.bottom, 100, 44);
    verifyTextField.borderStyle = UITextBorderStyleNone;
    verifyTextField.font = lblFont;
    verifyTextField.keyboardType =UIKeyboardTypeNumberPad;
    verifyTextField.textColor = textFieldColor;
    verifyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    verifyTextField.placeholder = @"手机验证码";
    verifyTextField.delegate = self;
    
    RTLineView *verifyLineView = [[RTLineView alloc] initWithFrame:CGRectMake(15, phoneLineView.bottom+45, 305, 1)];
    
    UILabel *passwordLbl = [UILabel new];
    passwordLbl.frame = CGRectMake(15, verifyLineView.bottom, 65, 44);
    passwordLbl.font = lblFont;
    passwordLbl.text = @"密码";
    passwordLbl.textColor = lblColor;
    
    UITextField *passwordTextField = [UITextField new];
    passwordTextField.frame = CGRectMake(82, verifyLineView.bottom, 175, 44);
    passwordTextField.borderStyle = UITextBorderStyleNone;
    passwordTextField.font = lblFont;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.textColor = textFieldColor;
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.placeholder = @"6-16位密码";
    passwordTextField.delegate = self;
    
    BrokerLineView *bottomLineView = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, verifyLineView.bottom+44.5, 320, 0.5)];
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(15, bottomLineView.bottom+20, 290, 40);
    [nextBtn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateHighlighted];
    
    [nextBtn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_lost"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateDisabled];
    
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *problemLbl = [[UILabel alloc] initWithFrame:CGRectMake(37, self.view.height-41-64, 150, 21)];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        problemLbl.top = self.view.height-41-44;
    }
    problemLbl.font = [UIFont ajkH5Font];
    problemLbl.textColor = [UIColor brokerMiddleGrayColor];
    problemLbl.text = @"如注册遇到问题，请拨打：";
    problemLbl.backgroundColor = [UIColor clearColor];
    
    UIButton *dailPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dailPhoneBtn.frame = CGRectMake(problemLbl.right, problemLbl.top, 80, problemLbl.height);
    [dailPhoneBtn setTitle:@"400-620-9008" forState:UIControlStateNormal];
    [dailPhoneBtn setTitleColor:[UIColor brokerBabyBlueColor] forState:UIControlStateNormal];
    dailPhoneBtn.titleLabel.font = [UIFont ajkH5Font];
    [dailPhoneBtn addTarget:self action:@selector(dialPhone) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *phoneView = [[UIView alloc] init];
    phoneView.frame = CGRectMake(0, topLineView.top, 320, 46);
    phoneView.backgroundColor = [UIColor whiteColor];
    
    
    UIView *verifyView = [[UIView alloc] init];
    verifyView.frame = CGRectMake(0, phoneLineView.top, 320, 46);
    verifyView.backgroundColor = [UIColor whiteColor];
    
    UIView *passwordView = [[UIView alloc] init];
    passwordView.frame = CGRectMake(0, verifyLineView.top, 320, 45);
    passwordView.backgroundColor = [UIColor whiteColor];
    
    
    [scrollView addSubview:phoneView];
    [scrollView addSubview:verifyView];
    [scrollView addSubview:passwordView];
    
    [scrollView addSubview:topLineView];
    [scrollView addSubview:phoneLbl];
    [scrollView addSubview:phoneTextField];
    [scrollView addSubview:verticalLineView];
    [scrollView addSubview:verifyBtn];
    [scrollView addSubview:phoneLineView];
    [scrollView addSubview:verifyLbl];
    [scrollView addSubview:verifyTextField];
    [scrollView addSubview:verifyLineView];
    [scrollView addSubview:passwordLbl];
    [scrollView addSubview:passwordTextField];
    [scrollView addSubview:bottomLineView];
    [scrollView addSubview:nextBtn];
    
    [scrollView addSubview:problemLbl];
    [scrollView addSubview:dailPhoneBtn];
    
    
    [self.view addSubview:scrollView];
    
    self.phoneTextField = phoneTextField;
    self.verifyTextField = verifyTextField;
    self.verifyBtn = verifyBtn;
    self.passwordTextField = passwordTextField;
    self.nextBtn = nextBtn;
    
    [self.nextBtn setEnabled:NO];
    
    //add observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.phoneTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.verifyTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.passwordTextField];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTitleViewWithString:@"注册"];
    [[BrokerLogger sharedInstance] logWithActionCode:REGISTER_PROP_1_ONVIEW page:REGISTER_PROP_1_PAGE note:nil];
    [[RTLocationManager sharedInstance] updateLocatedCityID];
}

- (void)doBack:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:REGISTER_PROP_1_CLICK_BACK page:REGISTER_PROP_1_GET_CODE note:nil];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.phoneTextField isFirstResponder]) {
        [self.phoneTextField resignFirstResponder];
    } else if ([self.verifyTextField isFirstResponder]) {
        [self.verifyTextField resignFirstResponder];
    } else if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
}

- (void)dialPhone {
    //make call
    [[BrokerCallAlert sharedCallAlert] callAlert:@"您是否要拨打客服热线：" callPhone:@"4006209008" appLogKey:PERSONAL_CLICK_CONFIRM_CSCALL page:PERSONAL completion:^(CFAbsoluteTime time) {
        nil;
    }];
}

- (void)textDidChange {
    if (self.phoneTextField.text.length >= 11 && self.verifyTextField.text.length > 0 &&  self.passwordTextField.text.length >= 6) {
        [self.nextBtn setEnabled:YES];
    } else {
        [self.nextBtn setEnabled:NO];
    }
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
    [[BrokerLogger sharedInstance] logWithActionCode:REGISTER_PROP_1_GET_CODE page:REGISTER_PROP_1_PAGE note:@{@"phone":self.phoneTextField.text}];
    
    [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:@"common/captcha/sms/" params:@{@"mobile":self.phoneTextField.text} target:self action:@selector(onReceiveVerifyCode:)];
    
    self.secondsCountDown = 60;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(timeFireMethod)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)onReceiveVerifyCode:(RTNetworkResponse *)response {
    DLog(@"response [%@]", [response content]);
    if ([response.content[@"status"] isEqualToString:@"error"]) {
        if (response.content[@"message"]) {
//            [self showInfo:response.content[@"message"]];
            if ([self.phoneTextField isFirstResponder]) {
                [self.phoneTextField resignFirstResponder];
            } else if ([self.verifyTextField isFirstResponder]) {
                [self.verifyTextField resignFirstResponder];
            } else if ([self.passwordTextField isFirstResponder]) {
                [self.passwordTextField resignFirstResponder];
            }
             [[HudTipsUtils sharedInstance] displayHUDWithStatus:@"error" Message:response.content[@"message"] ErrCode:@"1" toView:self.view];
        }
    }
}


- (void)timeFireMethod{
    self.secondsCountDown--;
    [self.verifyBtn setEnabled:NO];
    [self.verifyBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",self.secondsCountDown] forState:UIControlStateDisabled];
    [self.verifyBtn setTitleColor:[UIColor brokerLightGrayColor] forState:UIControlStateDisabled];
    
    if(self.secondsCountDown <= 0){
        self.secondsCountDown = 0;
        [self.countDownTimer invalidate];
        [self.verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.verifyBtn setTitleColor:[UIColor brokerBabyBlueColor] forState:UIControlStateNormal];
        [self.verifyBtn setEnabled:YES];
    }
}

- (void)nextAction {
    if ([self.verifyTextField.text isEqualToString:@"111111"]) {
        BrokerRegisterInfoViewController *controller = [BrokerRegisterInfoViewController new];
        if (self.phoneTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
            controller.beforeDic = @{@"mobile":self.phoneTextField.text, @"password":self.passwordTextField.text};
            NSString *cityID= [[RTLocationManager sharedInstance] locatedCityID];
            if (![cityID isEqual:@"-1"]) {
                [[RTCityInfoManager sharedInstance] setServiceType:RTAnjukeServiceID];
                RTCityInfo *cityInfo  = [[RTCityInfoManager sharedInstance] cityInfoWithCityID:cityID];
                if (cityInfo) {
                    controller.cityInfo = cityInfo;
                }
            }
        }
        
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    if (![self validatePhoneNum:self.phoneTextField.text] || ![self validateVerifyCode:self.verifyTextField.text] || ![self validatePassword:self.passwordTextField.text]) {
        return;
    }
    [[BrokerLogger sharedInstance] logWithActionCode:REGISTER_PROP_1_CLICK_NEXT page:REGISTER_PROP_1_PAGE note:@{@"phone":self.phoneTextField.text}];
    [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:@"common/captcha/verify/" params:@{@"mobile":self.phoneTextField.text,@"authCode":self.verifyTextField.text} target:self action:@selector(onCheckVerifyCode:)];
    
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
            NSString *cityID= [[RTLocationManager sharedInstance] locatedCityID];
            if (![cityID isEqual:@"-1"]) {
                [[RTCityInfoManager sharedInstance] setServiceType:RTAnjukeServiceID];
                RTCityInfo *cityInfo  = [[RTCityInfoManager sharedInstance] cityInfoWithCityID:cityID];
                if (cityInfo) {
                    controller.cityInfo = cityInfo;
                }
            }
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if (response.content && [response.content[@"status"] isEqualToString:@"error"]) {
        if (response.content[@"message"]) {
            if ([self.phoneTextField isFirstResponder]) {
                [self.phoneTextField resignFirstResponder];
            } else if ([self.verifyTextField isFirstResponder]) {
                [self.verifyTextField resignFirstResponder];
            } else if ([self.passwordTextField isFirstResponder]) {
                [self.passwordTextField resignFirstResponder];
            }
//            [self showInfo:response.content[@"message"]];
             [[HudTipsUtils sharedInstance] displayHUDWithStatus:@"error" Message:response.content[@"message"] ErrCode:@"1" toView:self.view];
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

#pragma mark - UITextFieldDelete
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
