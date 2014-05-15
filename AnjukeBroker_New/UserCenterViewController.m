//
//  UserCenterViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserHeaderView.h"
#import "UserCenterCell.h"
#import "BrokerTwoDimensionalCodeViewController.h"
#import "BrokerAccountController.h"
#import "BrokerCallAlert.h"
#import "AppSettingViewController.h"
#import "UserCenterModel.h"
#import "UserCenterModel.h"

#define SECTIONNUM 2
#define WCHATDATACELLHEIGHT 80

#define CALL_ANJUKE_NUMBER @"400-620-9008"
#define HEADERFRAME CGRectMake(0,0,[self windowWidth],200)
#define HEADERADDFRAME CGRectMake(0,-200,[self windowWidth],200)


@interface UserCenterViewController ()
@property(nonatomic, strong) UserHeaderView *headerView;
@property(nonatomic, strong) UITableView *tableList;
@property(nonatomic, strong) NSArray *taskArray;
//@property (nonatomic, strong) NSDictionary *clientDic;//客户主任
@property (strong, nonatomic) NSMutableDictionary *dataDic;//userInfo
@property (nonatomic, strong) UserCenterModel *userCenterModel;
@end

@implementation UserCenterViewController
@synthesize userCenterModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;

//    [self doUserInfoRequest];
}
- (void)initModel {
    self.taskArray = [NSArray arrayWithObjects:@"我的二维码", @"我的账户", @"个人信息", @"联系客户主任", @"客服热线", @"系统设置", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (self.userCenterModel == nil) {
        [self doRequest];
    }
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.headerView = [[UserHeaderView alloc] initWithFrame:HEADERFRAME];
    [self.headerView setImageView:[UIImage imageNamed:@"header"]];
    
    self.tableList = [[UITableView alloc] initWithFrame:FRAME_WITH_TAB style:UITableViewStylePlain];
    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.backgroundColor = [UIColor clearColor];
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.showsVerticalScrollIndicator = NO;
    self.tableList.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableList];

    [self.headerView updateUserHeaderInfo:[LoginManager getName]];
    
    UIImageView *showImg = [[UIImageView alloc] initWithFrame:HEADERADDFRAME];
    [showImg setImage:[UIImage imageNamed:@"header"]];
    showImg.contentMode = UIViewContentModeScaleToFill;
    [self.tableList addSubview:showImg];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, [self windowWidth], 50)];
    footView.backgroundColor = [UIColor clearColor];
    self.tableList.tableFooterView = footView;
}


#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SECTIONNUM;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 3;
        default:
            return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell showTopLine];
            [cell showBottonLineWithCellHeight:CELL_HEIGHT-1 andOffsetX:15];
            [cell initLabelTitle:[self.taskArray objectAtIndex:0]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1){
            [cell showBottonLineWithCellHeight:CELL_HEIGHT-1 andOffsetX:15];
            [cell initLabelTitle:[self.taskArray objectAtIndex:1]];
            [cell setDetailText:[self getAccountLeft]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.row == 2){
            [cell initLabelTitle:[self.taskArray objectAtIndex:2]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell showBottonLineWithCellHeight:CELL_HEIGHT];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [cell showTopLine];
            [cell showBottonLineWithCellHeight:CELL_HEIGHT-1 andOffsetX:15];
            [cell initLabelTitle:[self.taskArray objectAtIndex:3]];
            [cell setDetailText:[self getClientName]];
        }else if (indexPath.row == 1){
            [cell showBottonLineWithCellHeight:CELL_HEIGHT-1 andOffsetX:15];
            [cell initLabelTitle:[self.taskArray objectAtIndex:4]];
            [cell setDetailText:CALL_ANJUKE_NUMBER];
        }else if (indexPath.row == 2){
            [cell showBottonLineWithCellHeight:CELL_HEIGHT ];
            [cell initLabelTitle:[self.taskArray objectAtIndex:5]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.navigationController.view.frame.origin.x > 0)
        return;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BrokerTwoDimensionalCodeViewController *ba = [[BrokerTwoDimensionalCodeViewController alloc] init];
            [ba setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:ba animated:YES];
        }else if (indexPath.row == 2){
            [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_003 note:nil];

            //broker acunt
            BrokerAccountController *controller = [[BrokerAccountController alloc] init];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
            [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_008 note:nil];
            
            if (self.userCenterModel.tel) {
                //make call
                [[BrokerCallAlert sharedCallAlert] callAlert:[NSString stringWithFormat:@"您是否要联系客户主任%@：",[self getClientName]] callPhone:self.userCenterModel.tel  appLogKey:HZ_MORE_012];
            }
        }else if (indexPath.row == 1){
            [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_009 note:nil];

            //make call
            [[BrokerCallAlert sharedCallAlert] callAlert:@"您是否要拨打客服热线：" callPhone:CALL_ANJUKE_NUMBER appLogKey:HZ_MORE_013];
        }else if (indexPath.row == 2){
            AppSettingViewController *settingVC = [[AppSettingViewController alloc] init];
            settingVC.backType = RTSelectorBackTypePopBack;
            [settingVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)getClientName {
    NSString *str = [NSString string];
    
    if (self.userCenterModel == nil) {
        str = @"";
    }else {
//        str = [self.clientDic objectForKey:@"saleManagerName"];
        str = self.userCenterModel.ajkContact;
        if (str.length == 0) {
//            str = [self.clientDic objectForKey:@"saleManagerTel"];
            str = self.userCenterModel.tel;
        }
    }
    return str;
}

- (NSString *)getAccountLeft{
    NSString *str = @"";
    if (self.dataDic) {
        str = [NSString stringWithFormat:@"%@元", [self.dataDic objectForKey:@"balance"]];
    }
    return str;
}
#pragma mark - Request Method

- (void)doRequest {
    if (![self isNetworkOkay]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
//    method = @"broker/getsalemanager/";
    method = @"broker/callAnalysis/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}
- (void)onRequestFinished:(RTNetworkResponse *)response {
    DLog(@"。。。response [%@]", [response content]);
    if([[response content] count] == 0){
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        return;
    }
    
    NSDictionary *clientDic = [[NSDictionary alloc] initWithDictionary:[[response content] objectForKey:@"data"]];
    DLog(@"clientDic-->>%@",clientDic);
    
    self.userCenterModel = [[UserCenterModel alloc] convertToMappedObject:clientDic];
    [self.headerView updateWchatData:self.userCenterModel];
    
    [self.tableList reloadData];
    self.isLoading = NO;
}

#pragma mark - Request Method

//- (void)doUserInfoRequest {
//    if (![self isNetworkOkay]) {
//        [self hideLoadWithAnimated:YES];
//        self.isLoading = NO;
//        return;
//    }
//    
//    NSMutableDictionary *params = nil;
//    NSString *method = nil;
//    
//    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",[LoginManager getCity_id], @"cityId", nil];
//    method = @"broker/getinfo/";
//    
//    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onUserInfoRequestFinished:)];
//    self.isLoading = YES;
//}
//
//- (void)onUserInfoRequestFinished:(RTNetworkResponse *)response {
//    DLog(@"。。。response [%@]", [response content]);
//    if([[response content] count] == 0){
//        self.isLoading = NO;
//        [self showInfo:@"操作失败"];
//        return ;
//    }
//    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
//        
//        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
//        [alert show];
//        [self hideLoadWithAnimated:YES];
//        self.isLoading = NO;
//        return;
//    }
//    self.dataDic = [[[response content] objectForKey:@"data"] objectForKey:@"brokerInfo"];
//    [self.tableList reloadData];
//    [self.headerView updateUserHeaderInfo:self.dataDic];
//    
//    [self hideLoadWithAnimated:YES];
//    self.isLoading = NO;
//}


#pragma mark -UIScrollViewDelegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y <= -40) {
//        [self.headerView setLoading];
//    }
//    if (scrollView.contentOffset.y <= -80) {
//        [self.headerView hideLoading];
//    }
//    
//    [self.headerView scrollViewDrag:scrollView];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
