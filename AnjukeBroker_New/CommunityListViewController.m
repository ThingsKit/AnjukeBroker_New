//
//  CommunityListViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-5.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "CommunityListViewController.h"
#import "Util_UI.h"

@interface CommunityListViewController ()

@end

@implementation CommunityListViewController

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
    UITextField *cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 270, 30)];
    cellTextField.backgroundColor = [UIColor whiteColor];
    cellTextField.delegate = self;
    cellTextField.returnKeyType = UIReturnKeyDone;
    cellTextField.backgroundColor = [UIColor whiteColor];
    cellTextField.borderStyle = UITextBorderStyleNone;
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cellTextField.text = @"";
    cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cellTextField.placeholder = @"小区搜索";
    cellTextField.delegate = self;
    cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cellTextField.font = [UIFont systemFontOfSize:17];
    cellTextField.textAlignment = NSTextAlignmentCenter;
    cellTextField.secureTextEntry = NO;
    cellTextField.textColor = SYSTEM_BLACK;
    self.navigationItem.titleView = cellTextField;
}

- (void)doCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Textfield Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
