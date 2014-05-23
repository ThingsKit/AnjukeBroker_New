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
#import "HUDNews.h"
#import "CheckoutWebViewController.h"
#import "LoginManager.h"

#define SECTIONNUM 2
#define WCHATDATACELLHEIGHT 80

#define CALL_ANJUKE_NUMBER @"400-620-9008"
#define HEADERFRAME CGRectMake(0,0,[self windowWidth],200)
#define HEADERADDFRAME CGRectMake(0,-445,[self windowWidth],445)


@interface UserCenterViewController ()<goSDXDelegate>
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
#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:USER_CENTER_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

//- (void)sendDisAppearLog {
//    [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
//}
#pragma mark - view

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
    if (self.userCenterModel == nil) {
        [self doRequest];
    }
}
- (void)initModel {
    self.taskArray = [NSArray arrayWithObjects:@"我的二维码", @"我的账户", @"个人信息", @"联系客户主任", @"客服热线", @"系统设置", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    
    if (self.userCenterModel == nil) {
        [self doRequest];
    }
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    // Do any additional setup after loading the view.
    self.headerView = [[UserHeaderView alloc] initWithFrame:HEADERFRAME];
    self.headerView.sdxDelegate = self;
    [self.headerView setImageView:[UIImage imageNamed:@"userHeaderBg"]];
    
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
    [showImg setImage:[UIImage imageNamed:@"userHeadMoreBg"]];
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
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 20)];
    view.backgroundColor = [UIColor brokerBgPageColor];
    
    return view;
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
            [cell showBottonLineWithCellHeight:CELL_HEIGHT andOffsetX:15];
            [cell initLabelTitle:[self.taskArray objectAtIndex:0]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(265, 14, 22, 22)];
            [icon setImage:[UIImage imageNamed:@"user_ewm"]];
            [cell.contentView addSubview:icon];
        }else if (indexPath.row == 1){
            [cell showBottonLineWithCellHeight:CELL_HEIGHT andOffsetX:15];
            [cell initLabelTitle:[self.taskArray objectAtIndex:1]];
            [cell setDetailText:[self getAccountLeft] rightSpace:15];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.row == 2){
            [cell initLabelTitle:[self.taskArray objectAtIndex:2]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell showBottonLineWithCellHeight:CELL_HEIGHT];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [cell showTopLine];
            [cell showBottonLineWithCellHeight:CELL_HEIGHT andOffsetX:15];
            [cell initLabelTitle:[self.taskArray objectAtIndex:3]];
            [cell setDetailText:[self getClientName] rightSpace:35];
            
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(290, 17, 15, 15)];
            [icon setImage:[UIImage imageNamed:@"user_cell_phone_icon"]];
            [cell.contentView addSubview:icon];
        }else if (indexPath.row == 1){
            [cell showBottonLineWithCellHeight:CELL_HEIGHT andOffsetX:15];
            [cell initLabelTitle:[self.taskArray objectAtIndex:4]];
            [cell setDetailText:CALL_ANJUKE_NUMBER rightSpace:35];
            
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(290, 17, 15, 15)];
            [icon setImage:[UIImage imageNamed:@"user_cell_phone_icon"]];
            [cell.contentView addSubview:icon];
        }else if (indexPath.row == 2){
            [cell showBottonLineWithCellHeight:CELL_HEIGHT];
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
            [[BrokerLogger sharedInstance] logWithActionCode:USER_CENTER_004 note:nil];

            BrokerTwoDimensionalCodeViewController *ba = [[BrokerTwoDimensionalCodeViewController alloc] init];
            [ba setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:ba animated:YES];
        }else if (indexPath.row == 2){
            [[BrokerLogger sharedInstance] logWithActionCode:USER_CENTER_005 note:nil];

            //broker acunt
            BrokerAccountController *controller = [[BrokerAccountController alloc] init];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
            [[BrokerLogger sharedInstance] logWithActionCode:USER_CENTER_006 note:nil];
            
            if (self.userCenterModel.tel) {
                //make call
                [[BrokerCallAlert sharedCallAlert] callAlert:[NSString stringWithFormat:@"您是否要联系客户主任%@：",[self getClientName]] callPhone:self.userCenterModel.tel  appLogKey:USER_CENTER_007];
            }
        }else if (indexPath.row == 1){
            [[BrokerLogger sharedInstance] logWithActionCode:USER_CENTER_008 note:nil];

            //make call
            [[BrokerCallAlert sharedCallAlert] callAlert:@"您是否要拨打客服热线：" callPhone:CALL_ANJUKE_NUMBER appLogKey:USER_CENTER_009];
        }else if (indexPath.row == 2){
            [[BrokerLogger sharedInstance] logWithActionCode:USER_CENTER_010 note:nil];
            
            AppSettingViewController *settingVC = [[AppSettingViewController alloc] init];
            settingVC.backType = RTSelectorBackTypePopBack;
            [settingVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (self.userCenterModel) {
        str = [NSString stringWithFormat:@"%d元", [self.userCenterModel.balance intValue]];
    }
    return str;
}
#pragma mark - Request Method

- (void)doRequest {
    if (![self isNetworkOkay]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];
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
    DLog(@"response----->> [%@/%@]",[[response content] objectForKey:@"message"], [response content]);
    
    if([[response content] count] == 0){
        self.isLoading = NO;
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];
//        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"服务器开溜了" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];
        return;
    }
    
    NSDictionary *clientDic = [[NSDictionary alloc] initWithDictionary:[[response content] objectForKey:@"data"]];
    DLog(@"clientDic-->>%@",clientDic);
    
    self.userCenterModel = [UserCenterModel convertToMappedObject:clientDic];
    [self.headerView updateWchatData:self.userCenterModel];
    
    [self.tableList reloadData];
    self.isLoading = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
