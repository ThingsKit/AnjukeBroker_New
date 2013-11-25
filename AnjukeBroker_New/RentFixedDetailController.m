//
//  RentFixedDetailController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/4/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentFixedDetailController.h"
#import "PropertyResetViewController.h"
#import "RentAuctionViewController.h"
#import "ModifyFixedCostController.h"
#import "RTNavigationController.h"
#import "RentNoPlanController.h"
#import "ModifyRentCostController.h"
#import "RentSelectNoPlanController.h"

#import "SaleSelectNoPlanController.h"
#import "ModifyFixedCostController.h"

#import "FixedObject.h"
#import "BasePropertyObject.h"
#import "RentFixedCell.h"
#import "RentPropertyListCell.h"
#import "SaleFixedManager.h"
#import "LoginManager.h"
@interface RentFixedDetailController ()
{
    int selectIndex;
}
@end

@implementation RentFixedDetailController
@synthesize tempDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectIndex = 0;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"定价房源"];
    [self addRightButton:@"操作" andPossibleTitle:nil];
	// Do any additional setup after loading the view.
}
-(void)initModel{
    [super initModel];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", [self.tempDic objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/getplandetail/" params:params target:self action:@selector(onGetFixedInfo:)];
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
#pragma mark - 取消定价
-(void)doCancelFixed{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [[self.myArray objectAtIndex:selectIndex] objectForKey:@"id"], @"propId", [self.tempDic objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/cancelplan/" params:params target:self action:@selector(onCancelSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onCancelSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
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
#pragma mark - 重新开始定价
-(void)doRestartFixed{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.tempDic objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/spreadstart/" params:params target:self action:@selector(onRestartSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onRestartSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
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

#pragma mark - 请求定价组详情
-(void)doStopFixedGroup{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [self.tempDic objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/spreadstop/" params:params target:self action:@selector(onStopSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onStopSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
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

#pragma mark - UITableView Delegate & DataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectIndex = indexPath.row;
    if([indexPath row] == 0){
        
    }else{
        if([[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"isBid"] isEqualToString:@"1"]){
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == 0){
        return 71.0f;
    }
    return 85.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"[LoginManager isSeedForAJK:NO]%d",[LoginManager isSeedForAJK:NO]);
    if([indexPath row] == 0){
        static NSString *cellIdent = @"RentFixedCell";
        RentFixedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"RentFixedCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RentFixedCell"];
        }
        [cell configureCell:[self.myArray objectAtIndex:[indexPath row]] isAJK:NO];
        return cell;
    }else{
        static NSString *cellIdent = @"RentPropertyListCell";
        RentPropertyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"RentPropertyListCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RentPropertyListCell"];
            //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell configureCell:[self.myArray objectAtIndex:[indexPath row]]];
        return cell;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet.tag == 100){//正在推广中定价组
        if ([LoginManager isSeedForAJK:NO]) {
            if(buttonIndex == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要停止定价推广？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else if (buttonIndex == 1){//停止推广
                RentSelectNoPlanController *controller = [[RentSelectNoPlanController alloc] init];
                controller.fixedObj = [self.myArray objectAtIndex:0];
                controller.backType = RTSelectorBackTypeDismiss;
                RTNavigationController *navi = [[RTNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:navi animated:YES completion:nil];
                
            }else if (buttonIndex == 2){

            }

        }else{
            if(buttonIndex == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要停止定价推广？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else if (buttonIndex == 1){//停止推广
                ModifyRentCostController *controller = [[ModifyRentCostController alloc] init];
                controller.fixedObject = [self.myArray objectAtIndex:0];
                controller.backType = RTSelectorBackTypeDismiss;
                RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:nav animated:YES completion:nil];
                
            }else if (buttonIndex == 2){
                RentSelectNoPlanController *controller = [[RentSelectNoPlanController alloc] init];
                controller.fixedObj = [self.myArray objectAtIndex:0];
                controller.backType = RTSelectorBackTypeDismiss;
                RTNavigationController *navi = [[RTNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:navi animated:YES completion:nil];
            }
        }
            }else if(actionSheet.tag == 101){//当推广已暂停时的操作
                if([LoginManager isSeedForAJK:NO]){
                    if(buttonIndex == 0){
                        [self doRestartFixed];
                    }else if (buttonIndex == 1){//重新开始定价推广
                        RentSelectNoPlanController *controller = [[RentSelectNoPlanController alloc] init];
                        controller.fixedObj = [self.myArray objectAtIndex:0];
                        controller.backType = RTSelectorBackTypeDismiss;
                        RTNavigationController *navi = [[RTNavigationController alloc] initWithRootViewController:controller];
                        [self presentViewController:navi animated:YES completion:nil];
                    }else if (buttonIndex == 2){

                    }
                
                }else{
                    if(buttonIndex == 0){
                        [self doRestartFixed];
                    }else if (buttonIndex == 1){//重新开始定价推广
                        ModifyRentCostController *controller = [[ModifyRentCostController alloc] init];
                        controller.fixedObject = [self.myArray objectAtIndex:0];
                        controller.backType = RTSelectorBackTypeDismiss;
                        RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
                        [self presentViewController:nav animated:YES completion:nil];
                    }else if (buttonIndex == 2){
                        RentSelectNoPlanController *controller = [[RentSelectNoPlanController alloc] init];
                        controller.fixedObj = [self.myArray objectAtIndex:0];
                        controller.backType = RTSelectorBackTypeDismiss;
                        RTNavigationController *navi = [[RTNavigationController alloc] initWithRootViewController:controller];
                        [self presentViewController:navi animated:YES completion:nil];
                    }
                }

        
    }else{//对房源的操作
        if(buttonIndex == 0){
            RentAuctionViewController *controller = [[RentAuctionViewController alloc] init];
            controller.proDic = [self.myArray objectAtIndex:selectIndex];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.delegateVC = self;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:^(void){
                controller.proDic = [self.myArray objectAtIndex:selectIndex];
            }];
        }else if (buttonIndex == 1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要取消定价推广？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 105;
            [alert show];
            //            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if (buttonIndex == 2){
            PropertyResetViewController *controller = [[PropertyResetViewController alloc] init];
            controller.isHaozu = YES;
            controller.propertyID = [[self.myArray objectAtIndex:selectIndex] objectForKey:@"id"];
            controller.backType = RTSelectorBackTypeDismiss;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

#pragma mark -- privateMethod
-(void)rightButtonAction:(id)sender{
    if(self.isLoading){
        return ;
    }
    FixedObject *fix = [[FixedObject alloc] init];
    fix = [self.myArray objectAtIndex:0];
    
    if([fix.fixedStatus isEqualToString:@"1"]){
        if ([LoginManager isSeedForAJK:NO]) {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"停止推广", @"添加房源", nil];
            action.tag = 100;
            [action showInView:self.view];
        }else{
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"停止推广", @"修改限额", @"添加房源", nil];
            action.tag = 100;
            [action showInView:self.view];
        }

        
    }else{
        if([LoginManager isSeedForAJK:NO]){
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
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 105){
        if(buttonIndex == 1){
        [self doCancelFixed];
        }
    }else{
    
    if(buttonIndex == 1){
        [self doStopFixedGroup];
    }else{
        
    }
        
    }
}
@end
