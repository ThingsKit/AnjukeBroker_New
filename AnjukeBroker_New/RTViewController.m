//
//  AJK_RTViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-16.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "Util_UI.h"
#import "Reachability.h"
#import "AppManager.h"

#define TOP_ALERT_VIEW_HIDETIME 2.5

@interface RTViewController ()
@property (nonatomic, strong) UIView *topAlertView;
@end

@implementation RTViewController
@synthesize backType;
@synthesize isHome;
@synthesize delegateVC;
@synthesize isLoading;
@synthesize topAlertView;

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
    
    if (!SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        if (self.backType == RTSelectorBackTypePopBack || self.backType == RTSelectorBackTypePopToRoot) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        else {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self addBackButton];
    
    [self initModel];
    [self initDisplay];

}

#pragma mark -
#pragma mark 模态视图的返回动作

- (void)enterBackground {
//    [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
    [self hideLoadWithAnimated:YES];
}

- (void)dealloc {
    [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self sendAppearLog];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self hideLoadWithAnimated:NO];
    [self sendDisAppearLog];
    
    [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
}

-(void) sendAppearLog
{
    
}

-(void) sendDisAppearLog
{
    
}

#pragma mark - Status method

- (BOOL)isNetworkOkay {
    if (![[RTApiRequestProxy sharedInstance] isInternetAvailiable]) {
        [self showInfo:NONETWORK_STR];
        return NO;
    }
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([r currentReachabilityStatus] == NotReachable) {
        [self showInfo:NONETWORK_STR];
        return NO;
    }
    
    return YES;
}
- (BOOL)isNetworkOkayWithNoInfo {
    if (![[RTApiRequestProxy sharedInstance] isInternetAvailiable]) {
        return NO;
    }
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([r currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    
    return YES;
}
#pragma mark - private UI method

- (void)setTitleViewWithString:(NSString *)titleStr { //设置标题栏
    UILabel *lab = [UILabel getTitleView:titleStr];
    self.navigationItem.titleView = lab;
}

- (void)addBackButton {    
    //save btn
    if (self.isHome) {
        return;
    }
    if (self.backType == RTSelectorBackTypeNone) {
        return;
    }
    UIBarButtonItem *buttonItem;
    buttonItem = [UIBarButtonItem getBarButtonItemWithImage:[UIImage imageNamed:@"anjuke_icon_back.png"] highLihtedImg:[UIImage imageNamed:@"anjuke_icon_back_press.png"] taget:self action:@selector(doBack:)];
    if (self.backType == RTSelectorBackTypeDismiss) {
        buttonItem = [UIBarButtonItem getBackBarButtonItemForPresent:self action:@selector(doBack:)];
    }

    if (SYSTEM_VERSION_LESS_THAN(@"7.0")){
        if (self.backType == RTSelectorBackTypeDismiss){
            [self.navigationItem setLeftBarButtonItem:buttonItem];
        }else{
            UIBarButtonItem *spacer = [UIBarButtonItem getBarSpace:5.0];
            [self.navigationItem setLeftBarButtonItems:@[spacer, buttonItem]];
            [self.navigationController.navigationBar setTintColor:SYSTEM_NAVIBAR_COLOR];
        }
    }else{
        if (self.backType == RTSelectorBackTypeDismiss){
            UIBarButtonItem *spacer = [UIBarButtonItem getBarSpace:-10.0];
            [self.navigationItem setLeftBarButtonItems:@[spacer, buttonItem]];
            [self.navigationController.navigationBar setTintColor:SYSTEM_NAVIBAR_COLOR];
        }else{
            UIBarButtonItem *spacer = [UIBarButtonItem getBarSpace:-5.0];
            [self.navigationItem setLeftBarButtonItems:@[spacer, buttonItem]];
            [self.navigationController.navigationBar setTintColor:SYSTEM_NAVIBAR_COLOR];
        }
    }
}
- (void)addRightButton:(NSString *)title andPossibleTitle:(NSString *)possibleTitle {
    UIBarButtonItem *buttonItem = nil;
    //主要适应按钮正选和反选文字
    if (possibleTitle.length > 0 || possibleTitle != nil) {
        buttonItem = [UIBarButtonItem getBarButtonItemWithString:title taget:self action:@selector(rightButtonAction:)];
        if (!SYSTEM_VERSION_LESS_THAN(@"7.0")) {
//            buttonItem.tintColor = SYSTEM_NAVIBAR_COLOR;
            buttonItem.tintColor = [UIColor brokerBlueGrayColor];
        }
        buttonItem.possibleTitles = [NSSet setWithObject:possibleTitle];
        [self.navigationItem setRightBarButtonItem:buttonItem];
    }else{
        buttonItem = [UIBarButtonItem getBarButtonItemWithString:title taget:self action:@selector(rightButtonAction:)];
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [self.navigationItem setRightBarButtonItem:buttonItem];
        }else{//fix ios7 10像素偏离
            UIBarButtonItem *spacer = [UIBarButtonItem getBarSpace:-10.0];
            [self.navigationItem setRightBarButtonItems:@[spacer, buttonItem]];
        }
    }
}

- (void)doBack:(id)sender {
    if (self.backType == RTSelectorBackTypeDismiss) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.backType == RTSelectorBackTypePopBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.backType == RTSelectorBackTypePopToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)rightButtonAction:(id)sender {
    if (self.isLoading) {
        return;
    }
}

- (void)initModel {
    
}

- (void)initDisplay {
    
}

- (NSInteger)currentViewHeight {
    CGFloat H = 0;
    
    if (!self.navigationController) {
        H = ([[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height - STATUS_BAR_H);
    }
    else
        H = ([[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height - STATUS_BAR_H -NAV_BAT_H);
//    DLog(@"H [%f]", H);
    
    return H;
}

- (NSInteger)windowWidth {
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.width;
}

- (NSInteger)windowHeight {
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height;
}

- (void)showTopAlertWithTitle:(NSString *)title {
    UIView *topAlert = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 28)];
    topAlert.backgroundColor = [Util_UI colorWithHexString:@"efe0c3"];
    self.topAlertView = topAlert;
    [self.view addSubview:topAlert];
    
    CGFloat titleW = 120;
    CGFloat titleH = 20;
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake((topAlert.frame.size.width- titleW)/2, (topAlert.frame.size.height- titleH)/2, titleW, titleH)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.text = title;
    titleLb.textColor = [Util_UI colorWithHexString:@"ff8800"];
    titleLb.font = [UIFont systemFontOfSize:16];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [topAlert addSubview:titleLb];
    
    [self performSelector:@selector(hideTopAlertView) withObject:nil afterDelay:TOP_ALERT_VIEW_HIDETIME];
}

- (void)hideTopAlertView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.topAlertView.alpha = 0;
    } completion:^(BOOL finished){
        [self.topAlertView removeFromSuperview];
        self.topAlertView = nil;
    }];
}

#pragma mark - UIGesture Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.backType == RTSelectorBackTypePopToRoot) {
        //首页不做doBack
        return NO;
    }
    else {
        [self doBack:self];
    }
    
    return YES;
}

@end
