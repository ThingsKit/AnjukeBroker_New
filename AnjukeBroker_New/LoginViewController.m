//
//  LoginViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-4.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *passwordTF;
@end

@implementation LoginViewController
@synthesize nameTF, passwordTF;

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
    
}

- (void)doRequest {
    //test
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shtest", @"username", @"anjukeqa", @"password", nil];
    [[RTRequestProxy sharedInstance] asyncPostWithServiceID:RTAnjukeBrokerServiceID methodName:@"login/" params:params target:self action:@selector(onGetLogin:)];
}

- (void)onGetLogin:(RTNetworkResponse *) response {
    DLog(@"response [%@]", response);
    [response content];
    
}

@end
