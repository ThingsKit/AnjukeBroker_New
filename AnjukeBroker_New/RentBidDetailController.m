//
//  RentBidDetailController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/5/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentBidDetailController.h"
#import "PropertyEditViewController.h"
#import "RentAuctionViewController.h"
#import "RentBidNoPlanController.h"
#import "SaleAuctionViewController.h"
#import "SalePropertyListController.h"
#import "BaseBidPropertyCell.h"
#import "LoginManager.h"
#import "RentBidPropertyCell.h"
#import "CellHeight.h"
#import "RTGestureBackNavigationController.h"

@interface RentBidDetailController ()
{
    int selectedIndex;
}
@property (nonatomic, strong) UIActionSheet *myActionSheet;
@end

@implementation RentBidDetailController


#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_BID_DETAIL_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_BID_DETAIL_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectedIndex = 0;
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.myTable.delegate = nil;
    self.myTable.dataSource = nil;
    self.myTable = nil;
    [self.myActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"竞价房源"];
    [self addRightButton:@"新增" andPossibleTitle:nil];
	// Do any additional setup after loading the view.
}
-(void)initModel{
    [super initModel];
    self.myArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self doRequest];
//}

#pragma mark - 请求竞价房源列表

-(void)doRequest{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/bid/getplanprops/" params:params target:self action:@selector(onGetSuccess:)];
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
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    
    if (([[resultFromAPI objectForKey:@"propertyList"] count] == 0 || resultFromAPI == nil)) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到房源" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alert show];
        [self.myArray removeAllObjects];
        [self.myTable reloadData];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"没有竞价房源"];
        return;
    }
    [self.myArray removeAllObjects];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"propertyList"]];
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}
#pragma mark - 取消竞价
-(void)doCancelBid{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"id"], @"propId", [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"planId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/bid/cancelplan/" params:params target:self action:@selector(onCancelBidSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onCancelBidSuccess:(RTNetworkResponse *)response {
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
        [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_BID_DETAIL_009 note:[NSDictionary dictionaryWithObjectsAndKeys:@"false", @"jj_s", nil]];
        return;
    }
    if([[[response content] objectForKey:@"status"] isEqualToString:@"ok"]){
        [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_BID_DETAIL_009 note:[NSDictionary dictionaryWithObjectsAndKeys:@"true", @"jj_s", nil]];
    }
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    [self doRequest];
}
#pragma mark - 暂停竞价
-(void)doStopBid{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"id"], @"propId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/bid/spreadstop/" params:params target:self action:@selector(onStopBidSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onStopBidSuccess:(RTNetworkResponse *)response {
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
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    [self doRequest];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.navigationController.view.frame.origin.x > 0) {
        return;
    }
    selectedIndex = indexPath.row;
    if([[[self.myArray objectAtIndex:selectedIndex] objectForKey:@"bidStatus"] isEqualToString:@"3"]){
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重新开始竞价", @"取消竞价推广", @"修改房源信息", nil];
        action.tag = 101;
        if (self.myActionSheet) {
            self.myActionSheet = nil;
            self.myActionSheet.delegate = nil;
        }
        self.myActionSheet = action;
        [self.myActionSheet showInView:self.view];
    }else{
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"调整预算和出价", @"暂停竞价推广", @"修改房源信息", nil];
        action.tag = 102;
        if (self.myActionSheet) {
            self.myActionSheet = nil;
            self.myActionSheet.delegate = nil;
        }
        self.myActionSheet = action;
        [self.myActionSheet showInView:self.view];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGSize size = CGSizeMake(260, 40);
//    CGSize si = [[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
//    return si.height+88.0f;
    NSLog(@"========================>>>>>>>>>>%f", [CellHeight getBidCellHeight:[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"title"]]);
    return [CellHeight getBidCellHeight:[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdent = @"RentBidPropertyCell";
//    tableView.separatorColor = [UIColor lightGrayColor];
    RentBidPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    
    if(cell == nil){
        cell = [[NSClassFromString(@"RentBidPropertyCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RentBidPropertyCell"];
    }
    //    [cell setValueForCellByDictinary:[self.myArray objectAtIndex:[indexPath row]]];
    [cell setValueForCellByDataModel:[self.myArray objectAtIndex:[indexPath row]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark -- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 101){
        if (buttonIndex == 0){
            RentAuctionViewController *controller = [[RentAuctionViewController alloc] init];
            controller.proDic = [self.myArray objectAtIndex:selectedIndex];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.delegateVC = self;
            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:^(void){
            }];
        }else if (buttonIndex == 1){//重新开始竞价
            [self doCancelBid];
        }else if (buttonIndex == 2){//取消竞价
            [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_BID_DETAIL_005 note:nil];
            PropertyEditViewController *controller = [[PropertyEditViewController alloc] init];
            controller.isHaozu = YES;
            controller.pdId = HZ_PPC_BID_DETAIL;
            controller.propertyID = [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"id"];
            controller.backType = RTSelectorBackTypeDismiss;
            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            
        }
        
    }else{
        if (buttonIndex == 0){//调整预算
            [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_BID_DETAIL_006 note:nil];
            RentAuctionViewController *controller = [[RentAuctionViewController alloc] init];
            controller.proDic = [self.myArray objectAtIndex:selectedIndex];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.delegateVC = self;
            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:^{
            }];
        }else if (buttonIndex == 1){//手动暂停竞价
            [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_BID_DETAIL_007 note:nil];
            [self doStopBid];
        }else if (buttonIndex == 2){//修改房源
            [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_BID_DETAIL_005 note:nil];
            PropertyEditViewController *controller = [[PropertyEditViewController alloc] init];
            controller.isHaozu = YES;
            controller.pdId = HZ_PPC_BID_DETAIL;
            controller.propertyID = [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"id"];
            controller.backType = RTSelectorBackTypeDismiss;
            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            
        }
    }
    
}
#pragma mark -- PrivateMethod
-(void)rightButtonAction:(id)sender{
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_BID_NOPLAN_003 note:nil];
    
    if(self.isLoading){
        return ;
    }
    RentBidNoPlanController *controller = [[RentBidNoPlanController alloc] init];
    controller.backType = RTSelectorBackTypeDismiss;
    RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)doBack:(id)sender{
    [super doBack:self];
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_BID_NOPLAN_004 note:nil];
}
@end
