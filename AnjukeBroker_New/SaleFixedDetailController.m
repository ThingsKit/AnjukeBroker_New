//
//  SaleFixedDetailController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleFixedDetailController.h"
#import "BaseNoPlanController.h"
#import "ModifyFixedCostController.h"
#import "PropertyEditViewController.h"
#import "SaleSelectNoPlanController.h"
#import "SaleAuctionViewController.h"
#import "RTGestureBackNavigationController.h"

#import "SalePropertyListCell.h"
#import "SaleFixedCell.h"
#import "BasePropertyListCell.h"
#import "LoginManager.h"
#import "BasePropertyObject.h"
#import "SaleFixedManager.h"
#import "CellHeight.h"

#import "PropertyEditViewController.h"

@interface SaleFixedDetailController ()
{
    int selectIndex;
}
@property (nonatomic, strong) RTPopoverTableViewController *popoverTableView;
@property (nonatomic, strong) UIPopoverController *popoverBG;
@property (nonatomic, strong) NSArray *titleArr_Popover;

@end

@implementation SaleFixedDetailController
@synthesize popoverTableView, popoverBG;
@synthesize titleArr_Popover;
@synthesize tempDic;

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectIndex = 0;
        tempDic = [[NSMutableDictionary alloc] initWithCapacity:16];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DLog(@"==========%@",self.tempDic);
    [self setTitleViewWithString:@"定价房源"];
    //黑框
    self.titleArr_Popover= [NSArray arrayWithObjects:@"添加房源", @"停止推广", @"修改限额", nil];
    [self addRightButton:@"操作" andPossibleTitle:nil];
	// Do any additional setup after loading the view.
}
-(void)initModel{
    [super initModel];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self reloadData];
//}
//-(void)reloadData{
//
//    if(self.myArray == nil){
//        self.myArray = [NSMutableArray array];
//    }else{
//        [self.myArray removeAllObjects];
//    }
//    
//    [self.myTable reloadData];
//    
//    [self doRequest];
//}

-(void)dealloc{
    self.myTable.delegate = nil;
}

#pragma mark - 请求定价组详情
-(void)doRequest{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.tempDic objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/getplandetail/" params:params target:self action:@selector(onGetFixedInfo:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetFixedInfo:(RTNetworkResponse *)response {
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
    NSMutableDictionary *dicPlan = [[NSMutableDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"plan"]];
    self.planDic = [SaleFixedManager fixedPlanObjectFromDic:dicPlan];
    
    [self.myArray removeAllObjects];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"propertyList"]];
    if([self.myArray count] == 0) {
        [self.myTable reloadData];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"该定价组没有房源"];
        return;
    }
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}
#pragma mark - 取消定价推广房源
-(void)cancelFixedProperty{
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_007 note:nil];
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [[self.myArray objectAtIndex:selectIndex] objectForKey:@"id"], @"propId", [self.tempDic objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/cancelplan/" params:params target:self action:@selector(onCancelSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onCancelSuccess:(RTNetworkResponse *)response {
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
    [self reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
//    [self doRequest];
}

#pragma mark - 停止定价组计划推广
-(void)cancelFixedGroup{
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_003 note:nil];
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  [self.tempDic objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/spreadstop/" params:params target:self action:@selector(onCancelGroupSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onCancelGroupSuccess:(RTNetworkResponse *)response {
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
    [self reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
//    [self doRequest];
}
#pragma mark - 重新开始定价推广
-(void)doRestart{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  [self.tempDic objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/spreadstart/" params:params target:self action:@selector(onRestartSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onRestartSuccess:(RTNetworkResponse *)response {
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
    [self reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
//    [self doRequest];
}

#pragma mark - RTPOPOVER Delegate
- (void)popoverCellClick:(int)row {
    
}

#pragma mark - TableView Delegate && DataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.navigationController.view.frame.origin.x > 0) {
        return;
    }
    
    selectIndex = indexPath.row -1;
    
    if([indexPath row] == 0){
    
    }else{        
        if([[[self.myArray objectAtIndex:indexPath.row -1] objectForKey:@"isBid"] isEqualToString:@"1"]){
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"取消定价推广", @"修改房源信息", nil];
            action.tag = 102;
            [action showInView:self.view];
        }else{
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"竞价推广本房源", @"取消定价推广", @"修改房源信息", nil];
                action.tag = 103;
            [action showInView:self.view];
        }
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == 0){
    return 71.0f;
    }
    return [CellHeight getFixedCellHeight:[[self.myArray objectAtIndex:indexPath.row -1] objectForKey:@"title"]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == 0){
        static NSString *cellIdent = @"SaleFixedCell";
//        tableView.separatorColor = [UIColor lightGrayColor];
        SaleFixedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"SaleFixedCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SaleFixedCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        [cell configureCell:self.planDic isAJK:YES];
//        [cell configureCell:[self.myArray objectAtIndex:[indexPath row]]];
        return cell;
    }else{
        static NSString *cellIdent = @"SalePropertyListCell";
//        tableView.separatorColor = [UIColor lightGrayColor];
        SalePropertyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"SalePropertyListCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SalePropertyListCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        [cell configureCell:[self.myArray objectAtIndex:[indexPath row] -1]];
        [cell showBottonLineWithCellHeight:[CellHeight getFixedCellHeight:[[self.myArray objectAtIndex:indexPath.row -1] objectForKey:@"title"]]];
        return cell;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark -- privateMethod
-(void)rightButtonAction:(id)sender{
    if(self.isLoading){
        return ;
    }
    
    //    if (self.popoverBG) {
    //        [self.popoverBG dismissPopoverAnimated:YES];
    //		self.popoverBG = nil;
    //
    //        return;
    //    }
    
    //    RTPopoverTableViewController *ptv = [[RTPopoverTableViewController alloc] init];
    //    self.popoverTableView = ptv;
    //    ptv.view.backgroundColor = [UIColor clearColor];
    //    ptv.popoverDelegate = self;
    //    ptv.titleArray = [NSArray arrayWithArray:self.titleArr_Popover];
    //    [ptv setTableViewWithFrame:CGRectMake(0, 0, 198/2, 3* RT_POPOVER_TV_HEIGHT)];
    //    [self.view addSubview:ptv.view];
    
    //    UIPopoverController *pop = nil;
    //    pop = [[UIPopoverController alloc] init];
    //    self.popoverBG = pop;
    //    self.popoverBG.delegate = self;
    //    self.popoverBG.popoverContentSize = CGSizeMake(198/2, 3* RT_POPOVER_TV_HEIGHT); //popover View 大小
    ////    self.popoverBG.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
    //    [self.popoverBG presentPopoverFromRect:CGRectMake(0, 0, 20, 20)
    //                                            inView:self.navigationController.navigationBar
    //                          permittedArrowDirections:UIPopoverArrowDirectionUp
    //                                          animated:YES];
    if(self.planDic == nil){
        return;
    }
    FixedObject *fix = [[FixedObject alloc] init];
    fix = self.planDic;
    
    if([fix.fixedStatus isEqualToString:@"1"]){
        if ([LoginManager isSeedForAJK:YES]) {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"停止推广",@"添加房源", nil];
            action.tag = 100;
            [action showInView:self.view];
        }else{
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"停止推广", @"修改限额",@"添加房源", nil];
            action.tag = 100;
            [action showInView:self.view];
        }

    
    }else{
        if([LoginManager isSeedForAJK:YES]){
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"开始推广", @"添加房源", nil];
            action.tag = 101;
            [action showInView:self.view];
        
        }else{
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"开始推广", @"修改限额", @"添加房源", nil];
            action.tag = 101;
            [action showInView:self.view];
        
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popoverBG = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return YES;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(actionSheet.tag == 100){//停止推广
        if([LoginManager isSeedForAJK:YES]){//是播种城市
            if(buttonIndex == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要停止定价推广？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else if (buttonIndex == 1){//正在推广中定价组
                [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_005 note:nil];
                
                SaleSelectNoPlanController *controller = [[SaleSelectNoPlanController alloc] init];
                controller.fixedObj = self.planDic;
                controller.backType = RTSelectorBackTypeDismiss;
                RTGestureBackNavigationController *navi = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:navi animated:YES completion:nil];
            }else if (buttonIndex == 2){//正在推广中定价组

            }
        
        }else{
            if(buttonIndex == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要停止定价推广？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else if (buttonIndex == 1){
                [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_004 note:nil];
                ModifyFixedCostController *controller = [[ModifyFixedCostController alloc] init];
                controller.fixedObject = self.planDic;
                controller.backType = RTSelectorBackTypeDismiss;
                RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:nav animated:YES completion:nil];
                //            [self.navigationController pushViewController:controller animated:YES];
            }else if (buttonIndex == 2){//正在推广中定价组
                [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_005 note:nil];
                SaleSelectNoPlanController *controller = [[SaleSelectNoPlanController alloc] init];
                controller.fixedObj = self.planDic;
                controller.backType = RTSelectorBackTypeDismiss;
                RTGestureBackNavigationController *navi = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:navi animated:YES completion:nil];
            }
        }
        
    }else if(actionSheet.tag == 101){//当推广已暂停时的操作
        if ([LoginManager isSeedForAJK:YES]) {
            if(buttonIndex == 0){//重新开始定价推广
                [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_005 note:nil];
                [self doRestart];
                //            [self.navigationController pushViewController:controller animated:YES];
            }else if (buttonIndex == 1){
                [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_005 note:nil];
                SaleSelectNoPlanController *controller = [[SaleSelectNoPlanController alloc] init];
                controller.fixedObj = self.planDic;
                controller.backType = RTSelectorBackTypeDismiss;
                RTGestureBackNavigationController *navi = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:navi animated:YES completion:nil];
            }else if (buttonIndex == 2){

            }
        }else{
            if(buttonIndex == 0){//重新开始定价推广
                [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_009 note:nil];
                [self doRestart];
                //            [self.navigationController pushViewController:controller animated:YES];
            }else if (buttonIndex == 1){
                [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_009 note:nil];
                ModifyFixedCostController *controller = [[ModifyFixedCostController alloc] init];
                controller.fixedObject = self.planDic;
                controller.backType = RTSelectorBackTypeDismiss;
                RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:nav animated:YES completion:nil];
            }else if (buttonIndex == 2){
                [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_005 note:nil];
                SaleSelectNoPlanController *controller = [[SaleSelectNoPlanController alloc] init];
                controller.fixedObj = self.planDic;
                controller.backType = RTSelectorBackTypeDismiss;
                RTGestureBackNavigationController *navi = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:navi animated:YES completion:nil];
            }
        }


    }else if(actionSheet.tag == 102) {
        if(buttonIndex == 0){
            [self cancelFixedProperty];
        }else if (buttonIndex == 1){
            [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_008 note:nil];
            
            //test
            PropertyEditViewController *controller = [[PropertyEditViewController alloc] init];
            controller.propertyID = [[self.myArray objectAtIndex:selectIndex] objectForKey:@"id"];
            controller.backType = RTSelectorBackTypeDismiss;
            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }else if(actionSheet.tag == 103) {
            if(buttonIndex == 0){
                [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_006 note:nil];
                SaleAuctionViewController *controller = [[SaleAuctionViewController alloc] init];
                controller.proDic = [self.myArray objectAtIndex:selectIndex];
                controller.backType = RTSelectorBackTypeDismiss;
                controller.delegateVC = self;
                RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:nav animated:YES completion:^(void){
                    controller.proDic = [self.myArray objectAtIndex:selectIndex];
                }];
            }else if (buttonIndex == 1){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要取消定价推广？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 105;
                [alert show];
            }else if (buttonIndex == 2){
                [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_FIXED_DETAIL_008 note:nil];
                                
                //test
                PropertyEditViewController *controller = [[PropertyEditViewController alloc] init];
                controller.propertyID = [[self.myArray objectAtIndex:selectIndex] objectForKey:@"id"];
                controller.backType = RTSelectorBackTypeDismiss;
                RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:nav animated:YES completion:nil];
                
            }
    }
}
#pragma mark - UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 105){
        if(buttonIndex == 1){
            [self cancelFixedProperty];
        }
    }else{
        
        if(buttonIndex == 1){
            [self cancelFixedGroup];
        }else{
            
        }
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
