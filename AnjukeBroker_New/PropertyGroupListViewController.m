//
//  PropertyListViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-30.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PropertyGroupListViewController.h"
#import "AnjukePropertyGroupCell.h"
#import "PropertyAuctionViewController.h"
#import "LoginManager.h"
#import "PropertyAuctionPublishViewController.h"

@interface PropertyGroupListViewController ()
@property (nonatomic, strong) UITableView *tvList;
@property (nonatomic, strong) NSArray *groupArray;
@end

@implementation PropertyGroupListViewController
@synthesize tvList;
@synthesize groupArray;
@synthesize isBid;
@synthesize propertyID;
@synthesize commID;
@synthesize isHaozu;

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
    
    [self setTitleViewWithString:@"选择推广组"];
    [self doRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)initModel {
    self.groupArray = [NSArray array];
}

- (void)initDisplay {
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor clearColor];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    
}

#pragma mark - Request Method

- (void)doRequest { //获得定价推广组
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    if (self.isHaozu) {
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/getplans/" params:params target:self action:@selector(getFixPlanFinished:)];
    }
    else {
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/getplans/" params:params target:self action:@selector(getFixPlanFinished:)];
    }
    [self showLoadingActivity:YES];
    self.isLoading = YES;

}

- (void)getFixPlanFinished:(RTNetworkResponse *)response {
    DLog(@"---getGroupList---response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;

        return;
    }
    
    self.groupArray = [[[response content] objectForKey:@"data"] objectForKey:@"planList"];
    [self.tvList reloadData];
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

- (void)addPropertyToPlanWithGroupID:(NSString *)groupID{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  self.propertyID, @"propIds", groupID, @"planId", nil];
    
    NSString *methodStr = [NSString string];
    if (self.isHaozu) {
        methodStr = @"zufang/fix/addpropstoplan/";
    }
    else
        methodStr = @"anjuke/fix/addpropstoplan/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:methodStr params:params target:self action:@selector(addToFixFinished:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)addToFixFinished:(RTNetworkResponse *)response {
    DLog(@"---addToFix---response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;

        return;
    }
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;

    [self showInfo:@"房源加入定价组成功!"];
    
    if (self.isBid) { //去竞价页面
        PropertyAuctionPublishViewController *pa = [[PropertyAuctionPublishViewController alloc] init];
        pa.propertyID = [NSString stringWithFormat:@"%@", self.propertyID];
        pa.isHaozu = self.isHaozu;
        pa.commID = [NSString stringWithFormat:@"%@", self.commID];
        [self.navigationController pushViewController:pa animated:YES];
    }
    else { //去定价房源列表页面-结果页
        //test
        //        [self.navigationController popToRootViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - tableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PROPERTY_GROUP_CELL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    
    AnjukePropertyGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[AnjukePropertyGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    else {
        
    }
    
    [cell configureCell:[self.groupArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *groupID = [[self.groupArray objectAtIndex:indexPath.row] objectForKey:@"fixPlanId"];
    [self addPropertyToPlanWithGroupID:groupID];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
