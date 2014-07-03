//
//  PPCPriceingListViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PPCPriceingListViewController.h"
#import "PPCHouseCell.h"
#import "NSMutableArray+SWUtilityButtons.h"
#import "PPCPriceingListModel.h"
#import "PropertyEditViewController.h"
#import "RTGestureBackNavigationController.h"
#import "CommunityListViewController.h"

@interface PPCPriceingListViewController ()
@property(nonatomic, strong) NSMutableArray *tableData;
@property(nonatomic, strong) NSArray *lastedListData;
@property(nonatomic, strong) NSArray *oldListData;

@property(nonatomic, assign) BOOL isLoading;
@end

@implementation PPCPriceingListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.tableList && !self.isLoading) {
        [self autoPullDown];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitleViewWithString:@"定价推广"];
    [self addRightButton:@"发布" andPossibleTitle:nil];

    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.backgroundColor = [UIColor clearColor];
    self.tableList.rowHeight = 95;
    [self.view addSubview:self.tableList];

    [self autoPullDown];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.lastedListData.count == 0 && self.oldListData.count == 0) {
        return 0;
    }
    if (self.lastedListData.count > 0 && self.oldListData.count > 0) {
        return 2;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.lastedListData.count == 0 && self.oldListData.count == 0) {
        return nil;
    }
    if (self.lastedListData.count > 0 && self.oldListData.count > 0) {
        if (section == 0) {
            return nil;
        }else if (section == 1){
            return @"30天前发布房源";
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.lastedListData.count == 0 && self.oldListData.count == 0) {
        return 0.0;
    }
    if (self.lastedListData.count > 0 && self.oldListData.count > 0) {
        if (section == 0) {
            return 0.0;
        }else if (section == 1){
            return 40.0;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    PPCHouseCell *cell = (PPCHouseCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[PPCHouseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:identify
                               containingTableView:tableView
                                leftUtilityButtons:nil
                               rightUtilityButtons:[self getMenuButton]];
        cell.delegate = self;
    }
    
    
    PPCPriceingListModel *model = [PPCPriceingListModel convertToMappedObject:[self.tableData objectAtIndex:indexPath.row]];
    
    [cell configureCell:model withIndex:indexPath.row];
    if (indexPath.row != self.tableData.count - 1) {
        [cell showBottonLineWithCellHeight:95 andOffsetX:15];
    }else{
        [cell showBottonLineWithCellHeight:95 andOffsetX:0];
    }
    return cell;
}

- (NSMutableArray *)getMenuButton{
    NSMutableArray *btnArr = [NSMutableArray array];
    
    [btnArr sw_addUtilityButtonWithColor:[UIColor brokerLineColor] title:@"编辑"];
    [btnArr sw_addUtilityButtonWithColor:[UIColor brokerRedColor] title:@"删除"];
    
    return btnArr;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.tableData || self.navigationController.view.frame.origin.x > 0) {
        return;
    }
}

- (void)doRequest{
    self.isLoading = YES;
    NSMutableDictionary *params = nil;
    NSString *method = nil;

    if (self.isHaozu) {
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",self.planId,@"planId",[LoginManager getCity_id],@"cityId", nil];
        method = [NSString stringWithFormat:@"zufang/fix/props/"];
    }else{
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",self.planId,@"planId",[LoginManager getCity_id],@"cityId", nil];
        method = [NSString stringWithFormat:@"anjuke/fix/props/"];
    }

    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];

}
- (void)onRequestFinished:(RTNetworkResponse *)response{
    self.isLoading = NO;
    DLog(@"response---->>%@",[response content]);
    if([[response content] count] == 0){
        [self donePullDown];
        [self.tableList setTableStatus:STATUSFORNODATAFORPRICINGLIST];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
        
        [self.tableData removeAllObjects];
        [self.tableList reloadData];
        
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        DLog(@"message--->>%@",[[response content] objectForKey:@"message"]);

        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
        
        
        [self.tableData removeAllObjects];
        [self.tableList reloadData];
        
        [self donePullDown];
        return;
    }
    self.isLoading = NO;
    [self donePullDown];
    
    NSDictionary *resultData = [NSDictionary dictionaryWithDictionary:[response content][@"data"]];
    [self.tableData removeAllObjects];
    self.tableData = [[NSMutableArray alloc] init];
    
    if (resultData[@"newList"]) {
        self.lastedListData = [NSArray arrayWithArray:resultData[@"newList"]];
    }
    if (resultData[@"oldList"]) {
        self.oldListData = [NSArray arrayWithArray:resultData[@"oldList"]];
    }
    
    [self.tableData addObjectsFromArray:self.lastedListData];
    [self.tableData addObjectsFromArray:self.oldListData];

    if (self.tableData.count == 0) {
        [self.tableList setTableStatus:STATUSFORNODATAFORPRICINGLIST];
    }else{
        [self.tableList setTableStatus:STATUSFOROK];
    }
    [self.tableList reloadData];
}

//删除房源
- (void)doDeleteProperty:(NSString *)propertyID{
    self.isLoading = YES;
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        self.isLoading = NO;
        return;
    }
    //更新房源信息
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    if (self.isHaozu) {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getCity_id], @"cityId", [LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", propertyID, @"propIds", nil];
        method = @"zufang/prop/delprops/";
    }
    else {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", propertyID, @"propIds", nil];
        method = @"anjuke/prop/delprops/";
    }
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onDeletePropFinished:)];
}

- (void)onDeletePropFinished:(RTNetworkResponse *)response {
    DLog(@"--delete Prop。。。response [%@]", [response content]);
    
    if([[response content] count] == 0){
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
    }
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        
        //        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        return;
    }
    
    [[HUDNews sharedHUDNEWS] createHUD:@"删除房源成功" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALOK];
    
    [self autoPullDown];
}


- (void)rightButtonAction:(id)sender{
    CommunityListViewController *controller = [[CommunityListViewController alloc] init];
    controller.backType = RTSelectorBackTypeNone;
    controller.isFirstShow = YES;
    controller.isHaouzu = self.isHaozu;
    RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)tapGus:(UITapGestureRecognizer *)tap{
    [self autoPullDown];
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    DLog(@"didTriggerLeftUtilityButtonWithIndex-->>%d",index);
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    DLog(@"didTriggerRightUtilityButtonWithIndex-->>%d",index);
    
    NSIndexPath *indexPath = [self.tableList indexPathForCell:cell];
    if (index == 1) {
        [self doDeleteProperty:[self.tableData objectAtIndex:indexPath.row][@"propId"]];
    }else{
        PropertyEditViewController *controller = [[PropertyEditViewController alloc] init];
        controller.isHaozu = self.isHaozu;
//        controller.pdId = HZ_PPC_BID_DETAIL;
        controller.propertyID = [self.tableData objectAtIndex:indexPath.row][@"propId"];
        controller.backType = RTSelectorBackTypeDismiss;
        RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

