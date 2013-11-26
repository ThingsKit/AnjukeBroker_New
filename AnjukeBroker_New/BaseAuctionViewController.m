//
//  BaseAuctionViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-18.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "BaseAuctionViewController.h"
#import "SaleAuctionViewController.h"
#import "RentAuctionViewController.h"

@interface BaseAuctionViewController ()

@end

@implementation BaseAuctionViewController
@synthesize textField_1, textField_2;
@synthesize rangLabel;
@synthesize superVC;

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

- (void)initDisplay {
    //    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(doSure)];
    //    self.navigationItem.rightBarButtonItem = backBtn;
    
    [self addRightButton:@"确定" andPossibleTitle:nil];
    
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
        placeStr = @"";
    }
    
    UIView *BG = [[UIView alloc] initWithFrame:CGRectMake(0, 5 +index*(INPUT_VIEW_HEIGHT), [self windowWidth], INPUT_VIEW_HEIGHT)];
    BG.backgroundColor = [UIColor clearColor];
    [self.view addSubview:BG];
    
    CGFloat labelH = 20;
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_OFFSETX, (INPUT_VIEW_HEIGHT - labelH)/2, 50, labelH)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.text = title;
    titleLb.font = [UIFont systemFontOfSize:17];
    titleLb.textColor = SYSTEM_BLACK;
    [BG addSubview:titleLb];
    
    UITextField *cellTextField = nil;
    cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(titleLb.frame.origin.x + titleLb.frame.size.width, 0,  [self windowWidth] - (titleLb.frame.origin.x + titleLb.frame.size.width)-10, BG.frame.size.height)];
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
            self.textField_1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

        }
            break;
        case 1:
        {
            self.textField_2 = cellTextField;
            self.textField_2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
            break;
            
        default:
            break;
    }
    [BG addSubview:cellTextField];
    
    BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(TITLE_OFFSETX, INPUT_VIEW_HEIGHT - 0.5, [self windowWidth] - TITLE_OFFSETX, 0.5)];
    [BG addSubview:line];
    
}

- (void)checkRank {
    
}

#pragma mark - Request Method

-(void)doCheckRankWithPropID:(NSString *)propID commID:(NSString *)commID {
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", propID, @"propId", commID, @"commId", self.textField_2.text, @"offer", nil];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/getrank/" params:params target:self action:@selector(onCheckSuccess:)];
    [self showLoadingActivity:YES];
}

- (void)onCheckSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        return;
    }
    
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[response content]];
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    [self hideLoadWithAnimated:YES];
    
    self.rangLabel.alpha = 0.0;
    //test
    if([self.superVC isKindOfClass:[SaleAuctionViewController class]]){
    
    
    }
    self.rangLabel.text = [NSString stringWithFormat:@"预估排名:第%@名",[resultFromAPI objectForKey:@"data"]];
    
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
