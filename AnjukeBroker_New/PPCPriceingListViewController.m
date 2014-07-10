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
#import "RTGestureBackNavigationController.h"
#import "CommunityListViewController.h"
#import "PropertySingleViewController.h"
#import "PPCPlanIdRequest.h"
#import "BrokerLogger.h"
#import "RTGestureLock.h"

@interface PPCPriceingListViewController ()
@property(nonatomic, strong) NSMutableArray *tableData;
@property(nonatomic, strong) NSMutableArray *lastedListData;
@property(nonatomic, strong) NSMutableArray *oldListData;
@property(nonatomic, assign) BOOL isLoading;
@property(nonatomic, strong) NSString *propIDStr;
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

- (void)viewDidDisappear:(BOOL)animated{
    [self donePullDown];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    
    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJTG_LIST_ONVIEW page:ZF_DJTG_LIST_PAGE note:nil];
    }else{
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_DJTG_LIST_ONVIEW page:ESF_DJTG_LIST_PAGE note:nil];
    }
    
    // Do any additional setup after loading the view.

    if (self.isHaozu) {
        [self setTitleViewWithString:@"租房-定价推广"];
    }else{
        [self setTitleViewWithString:@"二手房-定价推广"];
    }

//    UIBarButtonItem *rightItem = [UIBarButtonItem getBarButtonItemWithImage:[UIImage imageNamed:@"anjuke_icon_add_.png"] highLihtedImg:[UIImage imageNamed:@"anjuke_icon_add_press"] taget:self action:@selector(rightButtonAction:)];
//    
//    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {//fix ios7以下 10像素偏离
//        UIBarButtonItem *spacer = [UIBarButtonItem getBarSpace:10.0];
//        [self.navigationItem setRightBarButtonItems:@[spacer, rightItem]];
//    }else{
//        self.navigationItem.rightBarButtonItem = rightItem;
//    }
    [self addRightButton:@"发布" andPossibleTitle:nil];

    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.backgroundColor = [UIColor whiteColor];
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
    return 2;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (self.lastedListData.count == 0 && self.oldListData.count == 0) {
//        return nil;
//    }
//    if (section == 0) {
//        return nil;
//    }else if (section == 1){
//        return @"30天前发布房源";
//    }
//    return nil;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *tit;
    float height;
    
    if (self.lastedListData.count == 0 && self.oldListData.count == 0) {
        tit = @"";
        height = 0;
    }
    if (section == 0) {
        tit = @"";
        height = 0;
    }else if (section == 1){
        tit = @"30天前发布房源";
        height = 40;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, height)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor brokerLightGrayColor];
    lab.font = [UIFont ajkH3Font];
    lab.text = tit;
    [view addSubview:lab];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.lastedListData.count == 0 && self.oldListData.count == 0) {
        return 0.0;
    }else{
        if (section == 0) {
            return 0;
        }
        if (section == 1) {
            if (self.oldListData.count > 0) {
                return 40;
            }else{
                return 0;
            }
        }
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.lastedListData.count;
    }else{
        return self.oldListData.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PPCHouseCell *cell = (PPCHouseCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    if (!cell) {
        cell = [[PPCHouseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:nil
                               containingTableView:tableView
                                leftUtilityButtons:nil
                               rightUtilityButtons:[self getMenuButton]];
        cell.delegate = self;
    }
    
    if (indexPath.section == 0) {
        PPCPriceingListModel *model = [PPCPriceingListModel convertToMappedObject:[self.lastedListData objectAtIndex:indexPath.row]];
        
        [cell configureCell:model withIndex:indexPath.row isHaoZu:self.isHaozu];
        
        if (indexPath.row != self.lastedListData.count - 1) {
            [cell showBottonLineWithCellHeight:95 andOffsetX:15];
        }else{
            [cell showBottonLineWithCellHeight:95 andOffsetX:0];
        }
    }else if (indexPath.section == 1){
        PPCPriceingListModel *model = [PPCPriceingListModel convertToMappedObject:[self.oldListData objectAtIndex:indexPath.row]];
        
        [cell configureCell:model withIndex:indexPath.row isHaoZu:self.isHaozu];

        if (indexPath.row == 0) {
            [cell showTopLine];
        }
        
        if (indexPath.row != self.oldListData.count - 1) {
            [cell showBottonLineWithCellHeight:95 andOffsetX:15];
        }else{
            [cell showBottonLineWithCellHeight:95 andOffsetX:0];
        }
    }
    
    return cell;
}

- (NSMutableArray *)getMenuButton{
    NSMutableArray *btnArr = [NSMutableArray array];
    
    [btnArr sw_addUtilityButtonWithColor:[UIColor brokerLineColor] title:@"编辑"];
    [btnArr sw_addUtilityButtonWithColor:[UIColor brokerRedColor] title:@"移除"];
    
    return btnArr;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.tableData || self.navigationController.view.frame.origin.x > 0) {
        return;
    }
    
    if (self.isLoading) {
        return;
    }
    
    NSString *properId;
    if (indexPath.section == 0) {
        properId = [self.lastedListData objectAtIndex:indexPath.row][@"propId"];
    }else if (indexPath.section == 1) {
        properId = [self.oldListData objectAtIndex:indexPath.row][@"propId"];
    }
    
    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJTG_LIST_CLICK_FY page:ZF_DJTG_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:properId,@"PROP_ID", nil]];
    }else{
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_DJTG_LIST_CLICK_FYDY page:ESF_DJTG_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:properId,@"PROP_ID", nil]];
    }
    
    PropertySingleViewController *singleVC = [[PropertySingleViewController alloc] init];
    singleVC.isHaozu = self.isHaozu;
    singleVC.propId = properId;
    singleVC.pageType = PAGE_TYPE_FIX;
    [self.navigationController pushViewController:singleVC animated:YES];
}
#pragma mark -- method
- (void)doRequest{
    self.isLoading = YES;

    if (![self isNetworkOkayWithNoInfo]) {
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        
        self.lastedListData = nil;
        self.oldListData = nil;
        [self.tableList reloadData];
        
        return;
    }
    
    if (!self.planId || [self.planId isEqualToString:@""]) {
        [[PPCPlanIdRequest sharePlanIdRequest] getPricingPlanId:self.isHaozu returnInfo:^(NSString *planId, RequestStatus status) {
            if (status == RequestStatusForOk) {
                self.planId = planId;
                [self doPricingRequest];
            } else {
                [self donePullDown];
                self.isLoading = NO;
                
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
                tapGes.delegate                = self;
                tapGes.numberOfTouchesRequired = 1;
                tapGes.numberOfTapsRequired    = 1;
                [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
                
                if (status == RequestStatusForNetRemoteServerError){
                    [self.tableList setTableStatus:STATUSFORREMOTESERVERERROR];
                }else if (status == RequestStatusForNetWorkError){
                    [self.tableList setTableStatus:STATUSFORNETWORKERROR];
                }
                
                [self.tableData removeAllObjects];
                [self.tableList reloadData];
            }
        }];
    }else{
        [self doPricingRequest];
    }
}

- (void)doPricingRequest{
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
    if(([[response content] count] == 0) || ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"])){
        if ([[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
            
            DLog(@"error---->>%@",[response content][@"message"]);
        }
        [self donePullDown];
        [self.tableList setTableStatus:STATUSFORREMOTESERVERERROR];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
        
        [self.tableData removeAllObjects];
        [self.tableList reloadData];
        
        return ;
    }

    self.isLoading = NO;
    [self donePullDown];
    
    NSDictionary *resultData = [NSDictionary dictionaryWithDictionary:[response content][@"data"]];
    [self.tableData removeAllObjects];
    self.tableData = [[NSMutableArray alloc] init];
    
    if (resultData[@"newList"]) {
        [self.lastedListData removeAllObjects];
        self.lastedListData = [NSMutableArray arrayWithArray:resultData[@"newList"]];
    }
    if (resultData[@"oldList"]) {
        [self.oldListData removeAllObjects];
        self.oldListData = [NSMutableArray arrayWithArray:resultData[@"oldList"]];
    }
    
    [self.tableData addObjectsFromArray:self.lastedListData];
    [self.tableData addObjectsFromArray:self.oldListData];

    if (self.tableData.count == 0) {
        [self.tableList setTableStatus:STATUSFORNODATAFORNOHOUSE];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
    }else{
        [self.tableList setTableStatus:STATUSFOROK];
    }
    [self.tableList reloadData];
}

//删除房源
- (void)doCancleProperty:(NSString *)propertyID{
    self.isLoading = YES;
    [self showLoadingActivity:YES];
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        self.isLoading = NO;
        return;
    }
    //更新房源信息
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    if (self.isHaozu) {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getCity_id], @"cityId", [LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", propertyID, @"propId",self.planId,@"planId", nil];
        method = @"zufang/fix/cancelplan/";
    }
    else {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", propertyID, @"propId",self.planId,@"planId", nil];
        method = @"anjuke/fix/cancelplan/";
    }
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onCanclePropFinished:)];
}

- (void)onCanclePropFinished:(RTNetworkResponse *)response {
    DLog(@"--delete Prop。。。response [%@]", [response content]);
    [self hideLoadWithAnimated:YES];
    if([[response content] count] == 0){
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
    }
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        DLog(@"errorMsg--->>%@",errorMsg);
        return;
    }
    
    [[HUDNews sharedHUDNEWS] createHUD:@"移除定价房源成功" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALOK];
    
    [self autoPullDown];
    
//    [self showLoadingActivity:YES];
//    [self performSelector:@selector(popBack) withObject:nil afterDelay:3.0];
}

- (void)popBack{
    [self hideLoadWithAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonAction:(id)sender{
    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJTG_LIST_CLICK_PUBLISH page:ZF_DJTG_LIST_PAGE note:nil];
    }else{
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_DJTG_LIST_CLICK_PUBLISH page:ESF_DJTG_LIST_PAGE note:nil];
    }
    
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
    
    NSIndexPath *path = [self.tableList indexPathForCell:cell];
    
    NSString *properId;
    if (path.section == 0) {
        properId = [self.lastedListData objectAtIndex:path.row][@"propId"];
    }else if (path.section == 1) {
        properId = [self.oldListData objectAtIndex:path.row][@"propId"];
    }
    
    if (index == 1) {
        if (self.isHaozu) {
            [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJTG_LIST_LEFT_CLICK_DELETE page:ZF_DJTG_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:properId,@"PROP_ID", nil]];
        }else{
            [[BrokerLogger sharedInstance] logWithActionCode:ESF_DJTG_LIST_LEFT_DELETE page:ESF_DJTG_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:properId,@"PROP_ID", nil]];
        }
        self.propIDStr = properId;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定移除房源?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"移除", nil];
        [alert show];
    }else{
        if (self.isHaozu) {
            [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJTG_LIST_LEFT_CLICK page:ZF_DJTG_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:properId,@"PROP_ID", nil]];
        }else{
            [[BrokerLogger sharedInstance] logWithActionCode:ESF_DJTG_LIST_LEFT_EDIT page:ESF_DJTG_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:properId,@"PROP_ID", nil]];
        }
        PropertyEditViewController *controller = [[PropertyEditViewController alloc] init];
        controller.propertyDelegate = self;
        controller.isHaozu = self.isHaozu;
        controller.propertyID = properId;
        controller.backType = RTSelectorBackTypeDismiss;
        RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)propertyDidDelete{
    DLog(@"删除成功");
    [self showLoadingActivity:YES];
    [self performSelector:@selector(popBack) withObject:nil afterDelay:3.0];
}


- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell nowStatus:(CellState)status{
    if (status == CellStateLeft || status == CellStateRight) {
        [RTGestureLock setDisableGestureForBack:(BK_RTNavigationController *)self.navigationController disableGestureback:YES];
    }
    if (status == CellStateCenter) {
        [RTGestureLock setDisableGestureForBack:(BK_RTNavigationController *)self.navigationController disableGestureback:NO];
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 2:{
            NSLog(@"right utility buttons open");
            NSIndexPath *path = [self.tableList indexPathForCell:cell];
            NSString *propID;
            if (path.section == 0) {
                propID = [self.lastedListData objectAtIndex:path.row][@"propId"];
            }else if (path.section == 1){
                propID = [self.oldListData objectAtIndex:path.row][@"propId"];
            }
            [self sendLeftSwipLogAndPropId:propID];
        }
            break;
        default:
            break;
    }
}

- (void)sendLeftSwipLogAndPropId:(NSString *)propId
{
    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJTG_LIST_LEFT page:ZF_DJTG_LIST_PAGE note:@{@"propId":propId}];
    } else {
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_DJTG_LIST_LEFT_HD page:ESF_DJTG_LIST_PAGE note:@{@"propId":propId}];
    }
}

#pragma mark --UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (self.isHaozu) {
            [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJTG_LIST_QQ_DELETE page:ZF_DJTG_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:self.propIDStr,@"PROP_ID", nil]];
        }else{
            [[BrokerLogger sharedInstance] logWithActionCode:ESF_DJTG_LIST_CLICK_DELETE page:ESF_DJTG_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:self.propIDStr,@"PROP_ID", nil]];
        }
        [self doCancleProperty:self.propIDStr];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

