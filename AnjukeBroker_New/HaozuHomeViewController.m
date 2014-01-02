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

#define HaozuHomeCellHeight 66.0f

@interface HaozuHomeViewController ()

@end

@implementation HaozuHomeViewController
@synthesize myTable;
@synthesize myArray;
@synthesize isSeedPid;

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_HOME_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"租房"];

	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
}
-(void)initModel{
    myArray = [NSMutableArray array];
}
-(void)initDisplay{
    [self addRightButton:@"发布" andPossibleTitle:nil];
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_BETWEEN_NAV_TAB style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTable];
}
-(void)dealloc{
    self.myTable.delegate = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    [self doRequest];
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

-(void)doRequest{
    if (self.isLoading == YES) {
//        return;
    }
    
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/prop/ppc/" params:params target:self action:@selector(onGetLogin:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetLogin:(RTNetworkResponse *)response {
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
    DLog(@"------response [%@]", [response content]);
    
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
        [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_HOME_003 note:nil];
        
        RentBidDetailController *controller = [[RentBidDetailController alloc] init];
        controller.backType = RTSelectorBackTypePopToRoot;
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([indexPath row] == [self.myArray count] - 1){
        [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_HOME_005 note:nil];
        
        RentNoPlanController *controller = [[RentNoPlanController alloc] init];
        controller.isSeedPid = self.isSeedPid;
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_HOME_004 note:nil];
        
        RentFixedDetailController *controller = [[RentFixedDetailController alloc] init];
        controller.tempDic = [self.myArray objectAtIndex:indexPath.row];
        controller.backType = RTSelectorBackTypePopToRoot;
        [controller setHidesBottomBarWhenPushed:YES];
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
//    tableView.separatorColor = [UIColor lightGrayColor];
    RentPPCGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[NSClassFromString(@"RentPPCGroupCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    [cell showBottonLineWithCellHeight:HaozuHomeCellHeight];
    [cell setValueForCellByData:self.myArray index:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)rightButtonAction:(id)sender{
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_HOME_006 note:nil];
    //模态弹出 --租房
    AnjukeEditPropertyViewController *controller = [[AnjukeEditPropertyViewController alloc] init];
    controller.backType = RTSelectorBackTypeDismiss;
    controller.isHaozu = YES;
    RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:YES completion:nil];
}
@end
