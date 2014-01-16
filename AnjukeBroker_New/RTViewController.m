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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBackButton];
    
    [self initModel];
    [self initDisplay];

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

#pragma mark - private UI method

- (void)setTitleViewWithString:(NSString *)titleStr { //设置标题栏
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 31)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:19];
    lb.text = titleStr;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = [Util_UI colorWithHexString:@"000000"];
    self.navigationItem.titleView = lb;
}

- (void)addBackButton {    
    //save btn
    if (self.isHome) {
        return;
    }
    
    NSString *title = @"返回";
    if (self.backType == RTSelectorBackTypeDismiss) {
        title = @"取消";
    }
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack:)];
    if (![AppManager isIOS6]) {
        backBtn.tintColor = SYSTEM_ORANGE;
        
    }
    
    self.navigationItem.leftBarButtonItem = backBtn;
    
//    if (self.backType == RTSelectorBackTypeDismiss) {
//        self.navigationItem.leftBarButtonItem = backBtn;
//    }
//    else {
//        if (![AppManager isIOS6]) {
//            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
//                                                     initWithTitle:@"返回"
//                                                     style:UIBarButtonItemStylePlain
//                                                     target:nil
//                                                     action:nil];
//            [self.navigationController.navigationBar setTintColor:SYSTEM_ORANGE];
//        }
//        else
//            self.navigationItem.leftBarButtonItem = backBtn;
//    }
    
}

- (void)addRightButton:(NSString *)title andPossibleTitle:(NSString *)possibleTitle {
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonAction:)];
    if (![AppManager isIOS6]) {
        rBtn.tintColor = SYSTEM_ORANGE;
    }
    if (possibleTitle.length > 0 || possibleTitle != nil) {
        rBtn.possibleTitles = [NSSet setWithObject:possibleTitle];
    }
    self.navigationItem.rightBarButtonItem = rBtn;
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

@end
