//
//  AnjukeOnlineImgController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/21/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "AnjukeOnlineImgController.h"
#import "LoginManager.h"

@interface AnjukeOnlineImgController ()

@end

@implementation AnjukeOnlineImgController
@synthesize imgArray;
@synthesize property;

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
    [self setTitleViewWithString:@"在线房型图"];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doRequest];
}
- (void)initModel{
    self.imgArray = [NSMutableArray array];
}
#pragma mark - Request OnlineImg
-(void)doRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"304133", @"commId", @"2", @"rommNum", @"2", @"hallNum", @"1", @"toiletNum", @"南", @"forward", @"1", @"pageNo", @"10", @"pageSize", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"img/gethousemoduleimg/" params:params target:self action:@selector(onGetLogin:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetLogin:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    if([resultFromAPI count] ==  0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return ;
    }
    [self.imgArray removeAllObjects];
    [self.imgArray addObjectsFromArray:[[resultFromAPI objectForKey:@"houseImg"] objectForKey:@"imgs"]];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
