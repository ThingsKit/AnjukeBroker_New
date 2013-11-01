//
//  PropertyAuctionViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-30.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PropertyAuctionViewController.h"
#import "BrokerLineView.h"
#import "Util_UI.h"
#import "SalePropertyListController.h"
#import "SaleFixedDetailController.h"
#import "SaleBidDetailController.h"

#define TITLE_OFFSETX 15
#define INPUT_VIEW_HEIGHT 45

@interface PropertyAuctionViewController ()
@property (nonatomic, strong) UITextField *textField_1;
@property (nonatomic, strong) UITextField *textField_2;
@property (nonatomic, strong) UILabel *rangLabel;
@end

@implementation PropertyAuctionViewController
@synthesize textField_1, textField_2;
@synthesize rangLabel;

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
    
    [self setTitleViewWithString:@"设置竞价"];
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
    //确认btn
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = ITEM_BTN_FRAME;
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn setTitleColor:SYSTEM_BLUE forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(doSure) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rButton;

    //draw input view
    for (int i = 0; i < 2; i ++) {
        [self drawInputBGWithIndex:i];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = SYSTEM_BLUE;
    btn.frame = CGRectMake(60, INPUT_VIEW_HEIGHT*2 + (42+20), [self windowWidth] - 60*2, 40);
    [btn setTitle:@"估  排  名" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(checkRank) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *rankLb = [[UILabel alloc] initWithFrame:CGRectMake(60, INPUT_VIEW_HEIGHT*2 + 42/2, [self windowWidth]- 60*2, 20)];
    rankLb.backgroundColor = [UIColor clearColor];
    rankLb.text = @"";
    rankLb.textColor = SYSTEM_BLACK;
    rankLb.textAlignment = NSTextAlignmentCenter;
    rankLb.font = [UIFont boldSystemFontOfSize:20];
    self.rangLabel = rankLb;
    [self.view addSubview:rankLb];
}

- (void)drawInputBGWithIndex:(int)index {
    NSString *title = nil;
    NSString *placeStr = nil;
    
    if (index == 0) {
        title = @"预算";
        placeStr = @"最低20元";
    }
    else {
        title = @"出价";
        placeStr = @"底价6.1元";
    }
    
    UIView *BG = [[UIView alloc] initWithFrame:CGRectMake(0, 5 +index*(INPUT_VIEW_HEIGHT), [self windowWidth], INPUT_VIEW_HEIGHT)];
    BG.backgroundColor = [UIColor clearColor];
    [self.view addSubview:BG];
    
    CGFloat labelH = 20;
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_OFFSETX, (INPUT_VIEW_HEIGHT - labelH)/2, 100, labelH)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.text = title;
    titleLb.font = [UIFont systemFontOfSize:17];
    titleLb.textColor = SYSTEM_BLACK;
    [BG addSubview:titleLb];
    
    UITextField *cellTextField = nil;
    cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(200, titleLb.frame.origin.x,  [self windowWidth] - 200-10, labelH)];
    cellTextField.returnKeyType = UIReturnKeyDone;
    cellTextField.backgroundColor = [UIColor clearColor];
    cellTextField.borderStyle = UITextBorderStyleNone;
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cellTextField.text = @"";
    cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cellTextField.placeholder = placeStr;
    cellTextField.delegate = self;
    cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cellTextField.font = [UIFont systemFontOfSize:17];
    cellTextField.textAlignment = NSTextAlignmentRight;
    cellTextField.secureTextEntry = NO;
    cellTextField.textColor = SYSTEM_LIGHT_GRAY;
    switch (index) {
        case 0:
        {
            self.textField_1 = cellTextField;
        }
            break;
        case 1:
        {
            self.textField_2 = cellTextField;
        }
            break;
            
        default:
            break;
    }
    [BG addSubview:cellTextField];
    
    BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(TITLE_OFFSETX, INPUT_VIEW_HEIGHT - 0.5, [self windowWidth] - TITLE_OFFSETX, 0.5)];
    [BG addSubview:line];
    
}

- (void)doSure {
    //test
    if ([self.delegateVC isKindOfClass:[SaleBidDetailController class]] || [self.delegateVC isKindOfClass:[SaleFixedDetailController class]] || [self.delegateVC isKindOfClass:[SalePropertyListController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

- (void)checkRank {
    self.rangLabel.alpha = 0.0;
    //test
    self.rangLabel.text = @"预估排名:第1名";
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.rangLabel.alpha = 1;
    [UIView commitAnimations];

}

#pragma mark - Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.textField_1]) {
        DLog(@"预算");
    }
    else if ([textField isEqual:self.textField_2]) {
        DLog(@"竞价");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField_1 resignFirstResponder];
    [self.textField_2 resignFirstResponder];
    
    return YES;
}

@end
