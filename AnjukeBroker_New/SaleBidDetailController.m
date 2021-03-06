//
//  SaleBidDetailController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleBidDetailController.h"
#import "BasePropertyObject.h"
#import "BaseBidPropertyCell.h"
#import "SalePropertyListController.h"
#import "PropertyEditViewController.h"
#import "SaleAuctionViewController.h"
#import "RTGestureBackNavigationController.h"
#import "LoginManager.h"
#import "SaleFixedManager.h"
#import "CellHeight.h"
#import "AuctionForbidView.h"

@interface SaleBidDetailController ()
{
    int selectedIndex;
}
@property (nonatomic, strong) UIActionSheet *myActionSheet;
@property (nonatomic, strong) AuctionForbidView *forbidView;
@end

@implementation SaleBidDetailController

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:ESF_JJ_LIST_ONVIEW page:ESF_JJ_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_BID_DETAIL_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
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
    [self setTitleViewWithString:@"竞价房源"];
	// Do any additional setup after loading the view.
}


-(void)dealloc{
    self.myTable.delegate = nil;
    self.myTable.dataSource = nil;
    self.myTable =nil;
    [self.myActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)initModel{
    [super initModel];
    selectedIndex = 0;
    self.myArray = [NSMutableArray array];
}

- (AuctionForbidView *)forbidView{
    if (!_forbidView) {
        _forbidView = [[AuctionForbidView alloc] init];
    }
    
    return _forbidView;
}

#pragma mark - 请求竞价房源列表
-(void)doRequest{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/getplanprops/" params:params target:self action:@selector(onGetSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}
- (void)onGetSuccess:(RTNetworkResponse *)response {
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
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    if([resultFromAPI count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return ;
    }
    
    if ([[resultFromAPI objectForKey:@"codeNum"] isEqualToString:@"133"]) {
        [self.myArray removeAllObjects];
        [self.myTable reloadData];
        [self hideLoadWithAnimated:YES];

        [self.view addSubview:self.forbidView];
        return;
    }
    
    [self addRightButton:@"新增" andPossibleTitle:nil];

    if (([[resultFromAPI objectForKey:@"propertyList"] count] == 0 || resultFromAPI == nil)) {
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
#pragma mark - 取消竞价推广
-(void)doStopBid{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"id"], @"propId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/spreadstop/" params:params target:self action:@selector(onStopSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}
- (void)onStopSuccess:(RTNetworkResponse *)response {
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

//    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;

    [self doRequest];
    
}
//文档缺失
#pragma mark - 取消竞价推广,(取消后房源不在竞价推广组)
-(void)doCancelBid{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"id"], @"propId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/cancelplan/" params:params target:self action:@selector(onCancelSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}
- (void)onCancelSuccess:(RTNetworkResponse *)response {
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
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_JJ_LIST_CLICK_CANCEL_JJ page:ESF_JJ_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:@"false", @"jj_s", nil]];
        return;
    }
    if([[[response content] objectForKey:@"status"] isEqualToString:@"ok"]){
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_JJ_LIST_CLICK_CANCEL_JJ page:ESF_JJ_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:@"true", @"jj_s", nil]];
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
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"调整预算和出价", @"暂停竞价推广",@"修改房源信息", nil];
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
    return [CellHeight getBidCellHeight:[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"BaseBidPropertyCell";
//    tableView.separatorColor = [UIColor lightGrayColor];
    BaseBidPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];

    if(cell == nil){
        cell = [[NSClassFromString(@"BaseBidPropertyCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BaseBidPropertyCell"];
     }
    [cell setValueForCellByDataModel:[self.myArray objectAtIndex:[indexPath row]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
//    headerLab.backgroundColor = [UIColor grayColor];
//    headerLab.text = @"房源数：5套";
//    return headerLab;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 101){
        if (buttonIndex == 0){//重新开始竞价
            SaleAuctionViewController *controller = [[SaleAuctionViewController alloc] init];
            controller.proDic = [self.myArray objectAtIndex:selectedIndex];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.delegateVC = self;
            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:^(void){
            }];
        }else if (buttonIndex == 1){//取消竞价
            [self doCancelBid];
        }else if (buttonIndex == 2){
            [[BrokerLogger sharedInstance] logWithActionCode:ESF_JJ_LIST_EDIT_PROP page:ESF_JJ_LIST_PAGE note:nil];
            PropertyEditViewController *controller = [[PropertyEditViewController alloc] init];
            controller.pdId = ESF_JJ_LIST_PAGE;
            controller.propertyID = [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"id"];
            controller.backType = RTSelectorBackTypeDismiss;
            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            
        }
    
    }else{
        if (buttonIndex == 0){//修改房源
            [[BrokerLogger sharedInstance] logWithActionCode:ESF_JJ_LIST_CLICK_CJJJ page:ESF_JJ_LIST_PAGE note:nil];
            SaleAuctionViewController *controller = [[SaleAuctionViewController alloc] init];
            controller.proDic = [self.myArray objectAtIndex:selectedIndex];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.delegateVC = self;
            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:^{
            }];
        }else if (buttonIndex == 1){//调整预算
            [[BrokerLogger sharedInstance] logWithActionCode:ESF_JJ_LIST_CLICK_STOPJJ page:ESF_JJ_LIST_PAGE note:nil];
            [self doStopBid];
        }else if (buttonIndex == 2){//手动暂停竞价
            [[BrokerLogger sharedInstance] logWithActionCode:ESF_JJ_LIST_EDIT_PROP page:ESF_JJ_LIST_PAGE note:nil];
            PropertyEditViewController *controller = [[PropertyEditViewController alloc] init];
            controller.pdId = ESF_JJ_LIST_PAGE;
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
    [[BrokerLogger sharedInstance] logWithActionCode:ESF_JJ_LIST_NEW page:ESF_JJ_LIST_PAGE note:nil];

    if(self.isLoading){
        return ;
    }
    SalePropertyListController *controller = [[SalePropertyListController alloc] init];
    controller.backType = RTSelectorBackTypeDismiss;
    RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)doBack:(id)sender{
    [super doBack:self];
    [[BrokerLogger sharedInstance] logWithActionCode:ESF_JJ_LIST_BACK page:ESF_JJ_LIST_PAGE note:nil];
}
@end
