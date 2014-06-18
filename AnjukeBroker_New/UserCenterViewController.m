//
//  UserCenterViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "UserCenterViewController.h"
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
#import "ClientListViewController.h"
#import "UserCenterHeaderCell.h"

#define SECTIONNUM 3
#define WCHATDATACELLHEIGHT 80

#define CALL_ANJUKE_NUMBER @"400-620-9008"
#define HEADERFRAME CGRectMake(0,0,[self windowWidth],200)
#define HEADERADDFRAME CGRectMake(0,-444,[self windowWidth],445)


@interface UserCenterViewController ()
@property(nonatomic, strong) UITableView *tableList;
@property(nonatomic, strong) NSArray *taskArray;
//@property (nonatomic, strong) NSDictionary *clientDic;//客户主任
@property (strong, nonatomic) NSMutableDictionary *dataDic;//userInfo
@property (nonatomic, strong) UserCenterModel *userCenterModel;
@property (nonatomic, assign) BOOL isSDX;
@end

@implementation UserCenterViewController
@synthesize userCenterModel;
@synthesize isSDX;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.backType = RTSelectorBackTypeNone;
        self.isSDX = NO;
    }
    return self;
}
#pragma mark - log
//- (void)sendAppearLog {
//    [[BrokerLogger sharedInstance] logWithActionCode:USER_CENTER_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
//}

//- (void)sendDisAppearLog {
//    [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
//}
#pragma mark - view

- (void)viewWillAppear:(BOOL)animated{
    [[BrokerLogger sharedInstance] logWithActionCode:PERSONAL_ONVIEW page:PERSONAL note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];

//    self.navigationController.navigationBarHidden = YES;
    
    if (self.userCenterModel == nil) {
        [self doRequest];
    }
}
- (void)initModel {
    self.taskArray = [NSArray arrayWithObjects:@"微聊客户",@"我的二维码", @"联系客户主任", @"客服热线", @"系统设置", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleViewWithString:@"我的"];
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    if (self.userCenterModel == nil) {
        [self doRequest];
    }
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableList = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.backgroundColor = [UIColor whiteColor];
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.tableList];

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, [self windowWidth], 50)];
    footView.backgroundColor = [UIColor clearColor];
    self.tableList.tableFooterView = footView;
}


#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 84;
    }
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5) {
        return 20;
    }
    return CELL_HEIGHT;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        cell.contentView.backgroundColor = [UIColor brokerBgPageColor];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row == 1) {
        UserCenterHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[UserCenterHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        [cell showTopLine];
        [cell showBottonLineWithCellHeight:84];
        [cell updateUserHeaderInfo:isSDX leftMoney:[self getAccountLeft]];
        
//        [cell updateUserHeaderInfo:isSDX leftMoney:[self getAccountLeft]];
        return cell;
    }else{
        UserCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[UserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }

        if (indexPath.row == 3) {
            [cell showTopLine];
            [cell showBottonLineWithCellHeight:CELL_HEIGHT andOffsetX:15];
            [cell initLabelTitle:[self.taskArray objectAtIndex:0]];
            cell.imageView.image = [UIImage imageNamed:@"broker_my_icon_client"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 4){
            [cell showBottonLineWithCellHeight:CELL_HEIGHT];
            [cell initLabelTitle:[self.taskArray objectAtIndex:1]];
            cell.imageView.image = [UIImage imageNamed:@"broker_my_icon_ewm"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 6) {
            [cell showTopLine];
            [cell showBottonLineWithCellHeight:CELL_HEIGHT andOffsetX:15];
            [cell initLabelTitle:[self.taskArray objectAtIndex:2]];
            [cell setDetailText:[self getClientName] rightSpace:35];
            cell.imageView.image = [UIImage imageNamed:@"broker_my_icon_ae"];
            
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(290, 17, 15, 15)];
            [icon setImage:[UIImage imageNamed:@"user_cell_phone_icon"]];
            [cell.contentView addSubview:icon];
        }else if (indexPath.row == 7){
            [cell showBottonLineWithCellHeight:CELL_HEIGHT andOffsetX:15];
            [cell initLabelTitle:[self.taskArray objectAtIndex:3]];
            [cell setDetailText:CALL_ANJUKE_NUMBER rightSpace:35];
            cell.imageView.image = [UIImage imageNamed:@"broker_my_icon_servicecall"];
            
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(290, 17, 15, 15)];
            [icon setImage:[UIImage imageNamed:@"user_cell_phone_icon"]];
            [cell.contentView addSubview:icon];
        }else if (indexPath.row == 8){
            [cell showBottonLineWithCellHeight:CELL_HEIGHT];
            [cell initLabelTitle:[self.taskArray objectAtIndex:4]];
            cell.imageView.image = [UIImage imageNamed:@"broker_my_icon_set"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.navigationController.view.frame.origin.x > 0)
        return;
    
    if (indexPath.row == 1){
        [[BrokerLogger sharedInstance] logWithActionCode:PERSONAL_CLICK_INFORMATION page:PERSONAL note:nil];
        
        //broker acunt
        BrokerAccountController *controller = [[BrokerAccountController alloc] init];
        controller.isSDX = isSDX;
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 3) {
        ClientListViewController *clientListVC = [[ClientListViewController alloc] init];
        [clientListVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:clientListVC animated:YES];
    }else if (indexPath.row == 4) {
        [[BrokerLogger sharedInstance] logWithActionCode:PERSONAL_QRCODE page:PERSONAL note:nil];
        
        BrokerTwoDimensionalCodeViewController *ba = [[BrokerTwoDimensionalCodeViewController alloc] init];
        [ba setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:ba animated:YES];
    }else if (indexPath.row == 6) {
        [[BrokerLogger sharedInstance] logWithActionCode:PERSONAL_CLICK_SALESCALL page:PERSONAL note:nil];
        
        if (self.userCenterModel.tel) {
            //make call
            [[BrokerCallAlert sharedCallAlert] callAlert:[NSString stringWithFormat:@"您是否要联系客户主任%@：",[self getClientName]] callPhone:self.userCenterModel.tel  appLogKey:PERSONAL_CLICK_CONFIRM_SALESCALL completion:^(CFAbsoluteTime time) {
                nil;
            }];
            //                [[BrokerCallAlert sharedCallAlert] callAlert:[NSString stringWithFormat:@"您是否要联系客户主任%@：",[self getClientName]] callPhone:self.userCenterModel.tel  appLogKey:USER_CENTER_007];
        }
    }else if (indexPath.row == 7){
        [[BrokerLogger sharedInstance] logWithActionCode:PERSONAL_CLICK_CSCALL page:PERSONAL note:nil];
        
        //make call
        [[BrokerCallAlert sharedCallAlert] callAlert:@"您是否要拨打客服热线：" callPhone:CALL_ANJUKE_NUMBER appLogKey:PERSONAL_CLICK_CONFIRM_CSCALL completion:^(CFAbsoluteTime time) {
            nil;
        }];
        //            [[BrokerCallAlert sharedCallAlert] callAlert:@"您是否要拨打客服热线：" callPhone:CALL_ANJUKE_NUMBER appLogKey:USER_CENTER_009];
    }else if (indexPath.row == 8){
        [[BrokerLogger sharedInstance] logWithActionCode:PERSONAL_CLICK_SYSSET page:PERSONAL note:nil];
        
        AppSettingViewController *settingVC = [[AppSettingViewController alloc] init];
        settingVC.backType = RTSelectorBackTypePopBack;
        [settingVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:settingVC animated:YES];
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
    if (self.userCenterModel) {
        str = [NSString stringWithFormat:@"%.2f", [self.userCenterModel.balance floatValue]];
    }
    return str;
}
#pragma mark - Request Method

- (void)doRequest {
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
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
    [self hideLoadWithAnimated:YES];

    if([[response content] count] == 0){
        self.isLoading = NO;
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
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

    if (self.userCenterModel && [self.userCenterModel.isTalent intValue] == 1) {
        isSDX = YES;
    }else{
        isSDX = NO;
    }

    [self.tableList reloadData];
    self.isLoading = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
