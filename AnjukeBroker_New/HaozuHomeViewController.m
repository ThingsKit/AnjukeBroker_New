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
#import "NoDataViewForESF.h"

#define HOME_cellHeight 50

@interface HaozuHomeViewController ()
@property(nonatomic, strong) PPCHeaderView *ppcHeadView;
@property(nonatomic, strong) NSDictionary *dataDic;
@property(nonatomic, strong) NoDataViewForESF *nodataView;
@end

@implementation HaozuHomeViewController
@synthesize myTable;
@synthesize myArray;
@synthesize isSeedPid;
@synthesize ppcHeadView;
@synthesize dataDic;

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
    
    dataDic = [[NSDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"hzDataDic"]];

    if ([resultFromAPI objectForKey:@"hzDataDic"]) {
        [self.ppcHeadView updatePPCData:[[NSMutableDictionary alloc] initWithDictionary:dataDic] isAJK:NO];
    }
    
    for (NSDictionary *tempDic in [dataDic objectForKey:@"hzFixHouse"]) {
        NSString *fixedStr = [NSString stringWithFormat:@"%@(%@)", @"定价房源", [tempDic objectForKey:@"fixNum"]];
        [self.myArray addObject:fixedStr];
    }
    if ([self.myArray count] == 1) {
        self.isSeedPid = [[[dataDic objectForKey:@"hzFixHouse"] objectAtIndex:0] objectForKey:@"fixId"];
    }
    NSString *bidStr = [NSString stringWithFormat:@"竞价房源(%@)", [dataDic objectForKey:@"hzBidHouseNum"]];
    NSString *noplanStr = [NSString stringWithFormat:@"待推广房源(%@)", [dataDic objectForKey:@"hzNotFixHouseNum"]];
    [self.myArray addObject:bidStr];
    [self.myArray addObject:noplanStr];
    [self.myTable reloadData];
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myArray.count > 2 && indexPath.row == self.myArray.count - 2) {//竞价
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_MANAGE_BIDLIST page:ZF_MANAGE note:nil];
        
        RentBidDetailController *controller = [[RentBidDetailController alloc] init];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (self.myArray.count > 1 && indexPath.row == self.myArray.count - 1) {//待推广
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_MANAGE_DRAFTLIST page:ZF_MANAGE note:nil];

        RentNoPlanController *controller = [[RentNoPlanController alloc] init];
        controller.isSeedPid = self.isSeedPid;
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_MANAGE_FIXLIST page:ZF_MANAGE note:nil];
        
        RentFixedDetailController *controller = [[RentFixedDetailController alloc] init];
        controller.tempDic = [[dataDic objectForKey:@"hzFixHouse"] objectAtIndex:indexPath.row];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HOME_cellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        if([[[[dataDic objectForKey:@"hzFixHouse"] objectAtIndex:0] objectForKey:@"fixStatus"] intValue] == 1){
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
