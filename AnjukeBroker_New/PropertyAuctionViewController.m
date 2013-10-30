//
//  PropertyAuctionViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-30.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PropertyAuctionViewController.h"
#import "BrokerLineView.h"

#define TITLE_OFFSETX 15

@interface PropertyAuctionViewController ()
@property (nonatomic, strong) UITextField *textField_1;
@property (nonatomic, strong) UITextField *textField_2;
@end

@implementation PropertyAuctionViewController
@synthesize textField_1, textField_2;

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
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(doSure) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rButton;

    //draw input view
    for (int i = 0; i < 2; i ++) {
        [self drawInputBGWithIndex:i];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    btn.frame = CGRectMake(TITLE_OFFSETX, 120, [self windowWidth] - TITLE_OFFSETX*2, 40);
    [btn setTitle:@"估  排  名" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(checkRank) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)drawInputBGWithIndex:(int)index {
    CGFloat BG_H = 40;
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
    
    UIView *BG = [[UIView alloc] initWithFrame:CGRectMake(0, 5 +index*(BG_H), [self windowWidth], BG_H)];
    BG.backgroundColor = [UIColor clearColor];
    [self.view addSubview:BG];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_OFFSETX, 5, 100, 35-5*2)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.text = title;
    titleLb.font = [UIFont systemFontOfSize:17];
    titleLb.textColor = [UIColor blackColor];
    [BG addSubview:titleLb];
    
    UITextField *cellTextField = nil;
    cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(200, 5,  [self windowWidth] - 200-10, BG_H - 5*2)];
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
    
    BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(TITLE_OFFSETX, BG_H - 0.5, [self windowWidth] - TITLE_OFFSETX, 0.5)];
    [BG addSubview:line];
    
}

- (void)doSure {
    //test
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)checkRank {
    
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
