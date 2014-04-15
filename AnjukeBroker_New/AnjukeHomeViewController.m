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

@interface AnjukeHomeViewController ()

@end

@implementation AnjukeHomeViewController
@synthesize myTable;
@synthesize myArray;
@synthesize isSeedPid;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleViewWithString:@"二手房"];
    
    [self addRightButton:@"发布" andPossibleTitle:nil];
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_BETWEEN_NAV_TAB style:UITableViewStylePlain];
//    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTable];

	// Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor yellowColor];
}
-(void)dealloc{
    self.myTable.delegate = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    [self doRequest];
//    [self doLog];

}
-(void)reloadData{
    if(self.myArray == nil){
        self.myArray = [NSMutableArray array];
    }else{
        [self.myArray removeAllObjects];
        [self.myTable reloadData];
    }
}
//-(void)doLog{
//    if(![self isNetworkOkay]){
//        return;
//    }
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
//    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"nlog/" params:params target:self action:@selector(onLogSuccess:)];
//    [self showLoadingActivity:YES];
//    self.isLoading = YES;
//}
//-(void)onLogSuccess:(RTNetworkResponse *)response {
//    DLog(@"%@",response.content);
//}
#pragma mark - 获取计划管理信息
-(void)doRequest{
    if (self.isLoading == YES) {
//        return;
    }
    
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
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
        controller.backType = RTSelectorBackTypePopToRoot;
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([indexPath row] == [self.myArray count] - 1){
        [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_HOME_005 note:nil];
        
        SaleNoPlanGroupController *controller = [[SaleNoPlanGroupController alloc] init];
        controller.isSeedPid = self.isSeedPid;
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_HOME_004 note:nil];
        
        SaleFixedDetailController *controller = [[SaleFixedDetailController alloc] init];
        controller.tempDic = [self.myArray objectAtIndex:indexPath.row];
        controller.backType = RTSelectorBackTypePopToRoot;
        [controller setHidesBottomBarWhenPushed:YES];
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
    [cell showBottonLineWithCellHeight:66.0f];
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
