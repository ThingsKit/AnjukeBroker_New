//
//  AJK_HaozuHomeViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "HaozuHomeViewController.h"
#import "RentFixedDetailController.h"
#import "AnjukePropertyResultController.h"
#import "AnjukeEditPropertyViewController.h"
#import "RentBidDetailController.h"
#import "RentNoPlanController.h"
#import "RentPPCGroupCell.h"
#import "LoginManager.h"
#import "RTGestureBackNavigationController.h"
#import "PPCHeaderView.h"

#define HaozuHomeCellHeight 66.0f

@interface HaozuHomeViewController ()
@property(nonatomic, strong) PPCHeaderView *ppcHeadView;
@end

@implementation HaozuHomeViewController
@synthesize myTable;
@synthesize myArray;
@synthesize isSeedPid;
@synthesize ppcHeadView;

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:ZF_MANAGE_ONVIEW page:ZF_MANAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_HOME_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
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
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    
    [self setTitleViewWithString:@"租房"];

	// Do any additional setup after loading the view.    
}
-(void)initModel{
    myArray = [NSMutableArray array];
}
-(void)initDisplay{
    [self addRightButton:@"发布" andPossibleTitle:nil];
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.backgroundColor = [UIColor clearColor];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTable.tableHeaderView = self.ppcHeadView;
    [self.view addSubview:myTable];
}
-(void)dealloc{
    self.myTable.delegate = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    [self doPPCRequest];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/prop/todayConsumeInfo/" params:params target:self action:@selector(onPPCGetSuccess:)];
    
//    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onPPCGetSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
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
    
    if ([resultFromAPI objectForKey:@"hzDataDic"]) {
        [self.ppcHeadView updatePPCData:[[NSMutableDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"hzDataDic"]] isAJK:NO];
    }
    
    NSMutableDictionary *bidPlan = [[NSMutableDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"bidPlan"]];
    [bidPlan setValue:@"1" forKey:@"type"];
    [self.myArray addObject:bidPlan];
    
    NSMutableArray *fixPlan = [NSMutableArray array];
    [fixPlan addObjectsFromArray:[resultFromAPI objectForKey:@"fixPlan"]];
    [self.myArray addObjectsFromArray:fixPlan];
    
    if([fixPlan count] == 1){
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
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_MANAGE_BIDLIST page:ZF_MANAGE note:nil];
        
        RentBidDetailController *controller = [[RentBidDetailController alloc] init];
        controller.backType = RTSelectorBackTypePopBack;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([indexPath row] == [self.myArray count] - 1){
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_MANAGE_DRAFTLIST page:ZF_MANAGE note:nil];
        
        RentNoPlanController *controller = [[RentNoPlanController alloc] init];
        controller.backType = RTSelectorBackTypePopBack;
        controller.isSeedPid = self.isSeedPid;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_MANAGE_FIXLIST page:ZF_MANAGE note:nil];
        
        RentFixedDetailController *controller = [[RentFixedDetailController alloc] init];
        controller.tempDic = [self.myArray objectAtIndex:indexPath.row];
        controller.backType = RTSelectorBackTypePopBack;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HaozuHomeCellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"RentPPCGroupCell";

    RentPPCGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[NSClassFromString(@"RentPPCGroupCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == 0) {
        [cell showTopLineWithOffsetX:15];
        [cell showBottonLineWithCellHeight:HaozuHomeCellHeight andOffsetX:15];
    }else if (indexPath.row != [self.myArray count] - 1) {
        [cell showBottonLineWithCellHeight:HaozuHomeCellHeight andOffsetX:15];
    }else{
        [cell showBottonLineWithCellHeight:HaozuHomeCellHeight];
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
    [[BrokerLogger sharedInstance] logWithActionCode:ZF_MANAGE_CLICK_PUBLISH page:ZF_MANAGE note:nil];
    
    //模态弹出小区--万恶的结构变动尼玛
    CommunityListViewController *controller = [[CommunityListViewController alloc] init];
    controller.backType = RTSelectorBackTypeNone;
    controller.isFirstShow = YES;
    controller.isHaouzu = YES;
    RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
