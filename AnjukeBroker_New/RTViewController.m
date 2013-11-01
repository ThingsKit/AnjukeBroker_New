//
//  AJK_RTViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-16.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "Util_UI.h"

@interface RTViewController ()

@end

@implementation RTViewController
@synthesize backType;
@synthesize isHome;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = ITEM_BTN_FRAME;
    [saveBtn setTitle:@"返回" forState:UIControlStateNormal];
    [saveBtn setTitleColor:SYSTEM_BLUE forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.leftBarButtonItem = rButton;
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

@end
