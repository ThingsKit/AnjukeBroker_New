//
//  AnjukeEditTextViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-12-2.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukeEditTextViewController.h"
#import "Util_UI.h"
#import "Util_TEXT.h"

@interface AnjukeEditTextViewController ()

@property (nonatomic, strong) UITextView *textV;
@end

@implementation AnjukeEditTextViewController
@synthesize textString;
@synthesize textFieldModifyDelegate;
@synthesize textV;
@synthesize isTitle;

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
    
    [self addRightButton:@"完成" andPossibleTitle:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textV becomeFirstResponder];
}

#pragma mark - private method
- (void)initModel {
    
}

- (void)initDisplay {
    
}

- (void)rightButtonAction:(id)sender {
    if (self.isTitle) {
        if (self.textV.text.length < 10) {
            [self showInfo:@"房源标题必须至少10个字符"];
            return;
        }
    }
    else {
        if (self.textV.text.length < 30) {
            [self showInfo:@"房源描述必须至少30个字符"];
            return;
        }
    }
    
    if ([self.textFieldModifyDelegate respondsToSelector:@selector(textDidInput:isTitle:)]) {
        [self.textFieldModifyDelegate textDidInput:self.textV.text isTitle:self.isTitle];
    }
    [self.textV resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTextFieldDetail:(NSString *)string {
    CGFloat TextViewH = 260;
    if ([self windowHeight] <= 960/2) {
        TextViewH = 180;
    }
    
    UITextView *cellTextField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], TextViewH)];
    cellTextField.returnKeyType = UIReturnKeyDone;
    cellTextField.backgroundColor = [UIColor clearColor];
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cellTextField.text = @"";
    cellTextField.delegate = self;
    cellTextField.font = [UIFont systemFontOfSize:17];
    cellTextField.secureTextEntry = NO;
    cellTextField.textColor = SYSTEM_BLACK;
    self.textV = cellTextField;
    [self.view addSubview:cellTextField];
    
    if (self.textV) {
        self.textV.text = string;
    }
}

- (void)doBack:(id)sender {
    if (!self.textV) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if ([[Util_TEXT rmBlankFromString:self.textV.text] isEqualToString:@""]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                 message:@"是否保存当前输入"
                                                delegate:self
                                       cancelButtonTitle:nil
                                       otherButtonTitles:@"不保存",@"保存并退出",nil];
    av.tag = 102;
    [av show];
}

#pragma mark - Text Field Delegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: //不保存
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        case 1: //保存并退出
        {
            [self rightButtonAction:self];
        }
            break;
        default:
            break;
    }
}

@end
