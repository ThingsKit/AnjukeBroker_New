//
//  BrokerAccountController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/26/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BrokerAccountController.h"
#import "BrokerAccountCell.h"
#import "LoginManager.h"
#import "BK_WebImageView.h"
#import "Util_UI.h"
#import "CheckoutWebViewController.h"

@interface BrokerAccountController ()

@end

@implementation BrokerAccountController
@synthesize myTable;
@synthesize ppcDataDic;
@synthesize dataDic;
@synthesize isSDX;

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
    self.navigationController.navigationBarHidden = NO;
    
    [self setTitleViewWithString:@"个人信息"];
	// Do any additional setup after loading the view.
}

- (void)initDisplay{
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 45)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 56, 18)];
    if (isSDX) {
        [imgView setImage:[UIImage imageNamed:@"broker_my_icon_freshman"]];
    }else{
        [imgView setImage:[UIImage imageNamed:@"broker_my_icon_nofreshman"]];
    }
    [headerView addSubview:imgView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 100, 15)];
    lab.text = isSDX ? @"你已经是闪电侠" : @"你还不是闪电侠";
    lab.textColor = [UIColor brokerLightGrayColor];
    lab.font = [UIFont ajkH4Font];
    [headerView addSubview:lab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(goSDX) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(180, 10, 100, 25);
    [btn setTitle:@"什么是闪电侠" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont ajkH4Font];
    [btn setTitleColor:[UIColor brokerBlueColor] forState:UIControlStateNormal];
    [headerView addSubview:btn];
    
    
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.backgroundColor = [UIColor clearColor];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTable.tableHeaderView = headerView;
    [self.view addSubview:self.myTable];
}

#pragma mark - method
- (void)goSDX{
    [[BrokerLogger sharedInstance] logWithActionCode:USER_CENTER_003 note:nil];
    
    CheckoutWebViewController *webVC = [[CheckoutWebViewController alloc] init];
    webVC.webTitle = @"闪电侠介绍";
    webVC.webUrl = [NSString stringWithFormat:@"http://api.anjuke.com/web/nearby/brokersign/shandianxia.html?city_id=%@",[LoginManager getCity_id]];
    [webVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)initModel{
    self.dataDic = [NSMutableDictionary dictionary];
    self.ppcDataDic =[NSMutableDictionary dictionary];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doRequest];

}


#pragma mark - Request Method
- (void)doRequest {
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",[LoginManager getCity_id], @"cityId", nil];
    method = @"broker/getinfo/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onRequestFinished:(RTNetworkResponse *)response {
    DLog(@"。。。response [%@]", [response content]);
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    self.dataDic = [[[response content] objectForKey:@"data"] objectForKey:@"brokerInfo"];
    [self.myTable reloadData];
//
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

#pragma mark - tableView Datasource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;//self.groupArray.count;
//    return [self.dataDic count] + [self.ppcDataDic count]- 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
//    tableView.separatorColor = [UIColor lightGrayColor];
    BrokerAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[BrokerAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    else {
    
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];

    [cell configureCell:self.dataDic withIndex:indexPath.row];
    if (indexPath.row == 0) {
        [cell showTopLineWithOffsetX:15];
    }
    if (indexPath.row == 5) {
        [cell showBottonLineWithCellHeight:45];
    }else{
        [cell showBottonLineWithCellHeight:45 andOffsetX:15];
    }
    return cell;
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
