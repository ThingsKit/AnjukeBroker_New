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

@interface AnjukeHomeViewController ()
@property(nonatomic, strong) PPCHeaderView *ppcHeadView;
@end

@implementation AnjukeHomeViewController
@synthesize myTable;
@synthesize myArray;
@synthesize isSeedPid;
@synthesize ppcHeadView;

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_HOME_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_HOME_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleViewWithString:@"二手房"];

    [self addRightButton:@"发布" andPossibleTitle:nil];
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
//    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTable.tableHeaderView = self.ppcHeadView;
    [self.view addSubview:self.myTable];

	// Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor yellowColor];
}

-(void)dealloc{
    self.myTable.delegate = nil;
    self.myTable.dataSource = nil;
    [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    [self doRequest];
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
    if (self.isLoading == YES) {
        //        return;
    }
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];

    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"broker/todayConsumeInfo/" params:params target:self action:@selector(onPPCGetSuccess:)];

    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onPPCGetSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);

    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"请求失败"];
        return ;
    }

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
        return ;
    }

    if ([resultFromAPI objectForKey:@"ajkDataDic"]) {
        [self.ppcHeadView updatePPCData:[[NSMutableDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"ajkDataDic"]] isAJK:YES];
    }

    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;

}

#pragma mark - 获取计划管理信息
-(void)doRequest{
    if (self.isLoading == YES) {
//        return;
    }
   
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/prop/ppc/" params:params target:self action:@selector(onGetSuccess:)];
    
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    [self.myArray removeAllObjects];
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    if([resultFromAPI count] ==  0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;

        return ;
    }
    DLog(@"resultFromAPI-->>%@",resultFromAPI);
    
    NSMutableDictionary *bidPlan = [[NSMutableDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"bidPlan"]];
    [bidPlan setValue:@"1" forKey:@"type"];
    [self.myArray addObject:bidPlan];
    
    NSMutableArray *fixPlan = [NSMutableArray array];
    [fixPlan addObjectsFromArray:[resultFromAPI objectForKey:@"fixPlan"]];
    [self.myArray addObjectsFromArray:fixPlan];
    if ([fixPlan count] == 1) {
        self.isSeedPid = [[fixPlan objectAtIndex:0] objectForKey:@"fixPlanId"];
    }
    NSMutableDictionary *nodic = [[NSMutableDictionary alloc] init];
    [nodic setValue:@"待推广房源" forKey:@"title"];
    [nodic setValue:[resultFromAPI objectForKey:@"unRecommendPropNum"] forKey:@"unRecommendPropNum"];
    [nodic setValue:@"1" forKey:@"type"];
    [self.myArray addObject:nodic];
    
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if([indexPath row] == 0)
    {

        [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_HOME_003 note:nil];
        
        SaleBidDetailController *controller = [[SaleBidDetailController alloc] init];
        controller.backType = RTSelectorBackTypePopBack;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([indexPath row] == [self.myArray count] - 1){
        [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_HOME_005 note:nil];
        
        SaleNoPlanGroupController *controller = [[SaleNoPlanGroupController alloc] init];
        controller.backType = RTSelectorBackTypePopBack;
        controller.isSeedPid = self.isSeedPid;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_HOME_004 note:nil];
        
        SaleFixedDetailController *controller = [[SaleFixedDetailController alloc] init];
        controller.tempDic = [self.myArray objectAtIndex:indexPath.row];
        controller.backType = RTSelectorBackTypePopBack;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"PPCGroupCell";
//    tableView.separatorColor = [UIColor lightGrayColor];
    PPCGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[NSClassFromString(@"PPCGroupCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        [cell showTopLineWithOffsetX:15];
        [cell showBottonLineWithCellHeight:66.0f andOffsetX:15];
    }else if (indexPath.row != [self.myArray count] - 1) {
        [cell showBottonLineWithCellHeight:66.0f andOffsetX:15];
    }else{
        [cell showBottonLineWithCellHeight:66.0f];
    }
    [cell setValueForCellByData:self.myArray index:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightButtonAction:(id)sender{
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_HOME_006 note:nil];
    
    //模态弹出小区--万恶的结构变动尼玛
    CommunityListViewController *controller = [[CommunityListViewController alloc] init];
    controller.backType = RTSelectorBackTypeDismiss;
    controller.isFirstShow = YES;
    RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
