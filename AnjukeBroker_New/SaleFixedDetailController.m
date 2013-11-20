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
#import "SalePropertyDetailController.h"
#import "PropertyResetViewController.h"
#import "SaleBidPlanController.h"
#import "SaleSelectNoPlanController.h"
#import "SaleAuctionViewController.h"
#import "RTNavigationController.h"

#import "SalePropertyListCell.h"
#import "SaleFixedCell.h"
#import "BasePropertyListCell.h"
#import "LoginManager.h"
#import "BasePropertyObject.h"
#import "SaleFixedManager.h"

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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}
-(void)reloadData{

    if(self.myArray == nil){
        self.myArray = [NSMutableArray array];
    }else{
        [self.myArray removeAllObjects];
        [self.myTable reloadData];
    }
    
    [self doRequest];
}

-(void)dealloc{
    self.myTable.delegate = nil;
}

#pragma mark - 请求定价组详情
-(void)doRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", @"1", @"resType", [self.tempDic objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/getplandetail/" params:params target:self action:@selector(onGetFixedInfo:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetFixedInfo:(RTNetworkResponse *)response {
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
    NSMutableDictionary *dicPlan = [[NSMutableDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"plan"]];
    [self.myArray removeAllObjects];
    [self.myArray addObject:[SaleFixedManager fixedPlanObjectFromDic:dicPlan]];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"propertyList"]];
    [self.myTable reloadData];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
}
#pragma mark - 取消定价推广房源
-(void)cancelFixedProperty{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [[self.myArray objectAtIndex:selectIndex] objectForKey:@"id"], @"propId", [self.tempDic objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/cancelplan/" params:params target:self action:@selector(onCancelSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onCancelSuccess:(RTNetworkResponse *)response {
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
}
#pragma mark - 停止定价组计划推广
-(void)cancelFixedGroup{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  [self.tempDic objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/spreadstop/" params:params target:self action:@selector(onCancelGroupSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onCancelGroupSuccess:(RTNetworkResponse *)response {
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
}
#pragma mark - 重新开始定价推广
-(void)doRestart{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"14e96260ca470b9afa52a48e3a54fb12", @"token", [LoginManager getUserID], @"brokerId",  [self.tempDic objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/spreadstart/" params:params target:self action:@selector(onRestartSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onRestartSuccess:(RTNetworkResponse *)response {
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
}

#pragma mark - RTPOPOVER Delegate
- (void)popoverCellClick:(int)row {
    
}

#pragma mark - TableView Delegate && DataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectIndex = indexPath.row;
    if([indexPath row] == 0){
    
    }else{
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改房源信息", @"取消定价推广", @"竞价推广本房源", nil];
        [action showInView:self.view];
        
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == 1){
    return 71.0f;
    }
    return 69.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([indexPath row] == 0){
        static NSString *cellIdent = @"SaleFixedCell";
        SaleFixedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"SaleFixedCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SaleFixedCell"];
        }
        [cell configureCell:[self.myArray objectAtIndex:[indexPath row]]];
        return cell;
    }else{
        static NSString *cellIdent = @"SalePropertyListCell";
        SalePropertyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"SalePropertyListCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SalePropertyListCell"];
        }
        [cell configureCell:[self.myArray objectAtIndex:[indexPath row]]];
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
    
    FixedObject *fix = [[FixedObject alloc] init];
    fix = [self.myArray objectAtIndex:0];
    
    if([fix.fixedStatus isEqualToString:@"1"]){
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加房源", @"停止推广", @"修改限额", nil];
        action.tag = 100;
        [action showInView:self.view];
    
    }else{
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加房源", @"开始推广", @"修改限额", nil];
        action.tag = 101;
        [action showInView:self.view];
    
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

    if(actionSheet.tag == 100){//正在推广中定价组
        if(buttonIndex == 0){
            SaleSelectNoPlanController *controller = [[SaleSelectNoPlanController alloc] init];
            controller.fixedObj = [self.myArray objectAtIndex:selectIndex];
            controller.backType = RTSelectorBackTypeDismiss;
            RTNavigationController *navi = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navi animated:YES completion:nil];
//            [self.navigationController pushViewController:controller animated:YES];
            
        }else if (buttonIndex == 1){//停止推广
            [self cancelFixedGroup];
        }else if (buttonIndex == 2){
            ModifyFixedCostController *controller = [[ModifyFixedCostController alloc] init];
            controller.fixedObject = [self.myArray objectAtIndex:0];
            controller.backType = RTSelectorBackTypeDismiss;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
//            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if(actionSheet.tag == 101){//当推广已暂停时的操作
        if(buttonIndex == 0){
            SaleSelectNoPlanController *controller = [[SaleSelectNoPlanController alloc] init];
            controller.fixedObj = [self.myArray objectAtIndex:selectIndex];
            controller.backType = RTSelectorBackTypeDismiss;
            RTNavigationController *navi = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navi animated:YES completion:nil];
            //            [self.navigationController pushViewController:controller animated:YES];
            
        }else if (buttonIndex == 1){//重新开始定价推广
            [self doRestart];
        }else if (buttonIndex == 2){
            ModifyFixedCostController *controller = [[ModifyFixedCostController alloc] init];
            controller.fixedObject = [self.myArray objectAtIndex:0];
            controller.backType = RTSelectorBackTypeDismiss;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
            //            [self.navigationController pushViewController:controller animated:YES];
        }

    }else{
        if(buttonIndex == 0){
            PropertyResetViewController *controller = [[PropertyResetViewController alloc] init];
            controller.propertyID = [[self.myArray objectAtIndex:selectIndex] objectForKey:@"id"];
            controller.backType = RTSelectorBackTypeDismiss;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }else if (buttonIndex == 1){
            [self cancelFixedProperty];
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if (buttonIndex == 2){
            SaleAuctionViewController *controller = [[SaleAuctionViewController alloc] init];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.delegateVC = self;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:^(void){
                controller.proDic = [self.myArray objectAtIndex:selectIndex];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
