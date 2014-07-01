//
//  AJK_AnjukeHomeViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukeHomeViewController.h"
#import "SaleNoPlanGroupController.h"
#import "SaleFixedDetailController.h"
#import "SaleBidDetailController.h"
#import "AnjukeEditPropertyViewController.h"
#import "AnjukeOnlineImgController.h"
#import "PPCGroupCell.h"
#import "LoginManager.h"
#import "SaleFixedManager.h"
#import "BrokerLogger.h"
#import "CommunityListViewController.h"
#import "RTGestureBackNavigationController.h"
#import "PPCHeaderView.h"
#import "NoDataViewForESF.h"

#define HOME_cellHeight 50

@interface AnjukeHomeViewController ()
@property(nonatomic, strong) PPCHeaderView *ppcHeadView;
@property(nonatomic, strong) NSDictionary *dataDic;
@property(nonatomic, strong) NoDataViewForESF *nodataView;

@end

@implementation AnjukeHomeViewController
@synthesize myTable;
@synthesize myArray;
@synthesize isSeedPid;
@synthesize ppcHeadView;
@synthesize dataDic;

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:ESF_MANAGE_ONVIEW page:ESF_MANAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_HOME_002 page:ESF_MANAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (PPCHeaderView *)ppcHeadView{
    if (ppcHeadView == nil) {
        ppcHeadView = [[PPCHeaderView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 100)];
        ppcHeadView.backgroundColor = [UIColor whiteColor];
    }
    return ppcHeadView;
}

- (NoDataViewForESF *)nodataView {
    if (_nodataView == nil) {
        _nodataView = [[NoDataViewForESF alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    return _nodataView;
}

- (void)showNodataVeiw {
    self.myTable.hidden = YES;
    [self.nodataView removeFromSuperview];
    [self.view addSubview:self.nodataView];
    [self.nodataView showNoDataView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    
    [self setTitleViewWithString:@"二手房"];

    [self addRightButton:@"发布" andPossibleTitle:nil];
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
//    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTable.tableHeaderView = self.ppcHeadView;
    self.myTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.myTable];

	// Do any additional setup after loading the view.
}

-(void)dealloc{
    self.myTable.delegate = nil;
    self.myTable.dataSource = nil;
    [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    [self doPPCRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self sendAppearLog];
    [self hideLoadWithAnimated:YES];
    
}

-(void)reloadData{
    if(self.myArray == nil){
        self.myArray = [NSMutableArray array];
    }else{
        [self.myArray removeAllObjects];
        [self.myTable reloadData];
    }
}

#pragma mark - 获取计划管理信息
-(void)doPPCRequest{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];

    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/prop/todayConsumeInfo/" params:params target:self action:@selector(onPPCGetSuccess:)];

    self.isLoading = YES;
}

- (void)onPPCGetSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);

    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        [self showNodataVeiw];
        return ;
    }

    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
//        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
 
        return;
    }

    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    if([resultFromAPI count] ==  0){
        return ;
    }

    dataDic = [[NSDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"ajkDataDic"]];

    if ([resultFromAPI objectForKey:@"ajkDataDic"]) {
        [self.ppcHeadView updatePPCData:[[NSMutableDictionary alloc] initWithDictionary:dataDic] isAJK:YES];
    }
    

    for (NSDictionary *tempDic in [dataDic objectForKey:@"ajkFixHouse"]) {
        NSString *fixedStr = [NSString stringWithFormat:@"%@(%@)", @"定价房源", [tempDic objectForKey:@"fixNum"]];
        [self.myArray addObject:fixedStr];
    }
    if ([self.myArray count] == 1) {
        self.isSeedPid = [[[dataDic objectForKey:@"ajkFixHouse"] objectAtIndex:0] objectForKey:@"fixId"];
    }
    NSString *bidStr = [NSString stringWithFormat:@"竞价房源(%@)", [dataDic objectForKey:@"ajkBidHouseNum"]];
    NSString *noplanStr = [NSString stringWithFormat:@"待推广房源(%@)", [dataDic objectForKey:@"ajkNotFixHouseNum"]];
    [self.myArray addObject:bidStr];
    [self.myArray addObject:noplanStr];

    [self.myTable reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.myArray.count > 2 && indexPath.row == self.myArray.count - 2) {//竞价
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_MANAGE_FIXLIST page:ESF_MANAGE note:nil];

        SaleBidDetailController *controller = [[SaleBidDetailController alloc] init];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (self.myArray.count > 1 && indexPath.row == self.myArray.count - 1) {//待推广
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_MANAGE_BIDLIST page:ESF_MANAGE note:nil];
        
        SaleNoPlanGroupController *controller = [[SaleNoPlanGroupController alloc] init];
        controller.isSeedPid = self.isSeedPid;
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_MANAGE_DRAFTLIST page:ESF_MANAGE note:nil];

        SaleFixedDetailController *controller = [[SaleFixedDetailController alloc] init];
        controller.tempDic = [[dataDic objectForKey:@"ajkFixHouse"] objectAtIndex:indexPath.row];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HOME_cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentify = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        [cell setBackgroundColor:[UIColor whiteColor]];

    }
    cell.textLabel.text = [self.myArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor brokerBlackColor];
    cell.textLabel.font = [UIFont ajkH2Font];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == self.myArray.count - 1) {
        BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(15, 0.5f, 320 - 15, 0.5f)];
        [cell.contentView addSubview:line];
        
        BrokerLineView *line1 = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, HOME_cellHeight - 0.5f, 320, 0.5f)];
        [cell.contentView addSubview:line1];
    }else {
        BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(15, 0.5f, 320 - 15, 0.5f)];
        [cell.contentView addSubview:line];
    }
    
    if (indexPath.row == 0) {
        UIImageView *statueImg = [[UIImageView alloc] initWithFrame:CGRectMake(260, 18, 30, 13)];
        if([[[[dataDic objectForKey:@"ajkFixHouse"] objectAtIndex:0] objectForKey:@"fixStatus"] intValue] == 1){
            [statueImg setImage:[UIImage imageNamed:@"anjuke_icon09_woking.png"]];
        }else{
            [statueImg setImage:[UIImage imageNamed:@"anjuke_icon09_stop.png"]];
        }
        [cell.contentView addSubview:statueImg];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightButtonAction:(id)sender{
    [[BrokerLogger sharedInstance] logWithActionCode:ESF_MANAGE_CLICK_PUBLISH page:ESF_MANAGE note:nil];
    
    //模态弹出小区--万恶的结构变动尼玛
    CommunityListViewController *controller = [[CommunityListViewController alloc] init];
    controller.backType = RTSelectorBackTypeNone;
    controller.isFirstShow = YES;
    RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
