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
#import "BidPropertyDetailController.h"
#import "SalePropertyListController.h"
#import "AnjukeEditPropertyViewController.h"
#import "SaleBidPlanController.h"
#import "PropertyAuctionViewController.h"
#import "RTNavigationController.h"
#import "LoginManager.h"
#import "SaleFixedManager.h"

@interface SaleBidDetailController ()
{
    int selectedIndex;
}
@end

@implementation SaleBidDetailController

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
    [self setTitleViewWithString:@"竞价推广"];
    [self addRightButton:@"新增" andPossibleTitle:nil];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    [self doRequest];
}
-(void)reloadData{
    if(self.myArray == nil){
        self.myArray = [NSMutableArray array];
    }else{
        [self.myArray removeAllObjects];
        [self.myTable reloadData];
    }
}

-(void)dealloc{
    self.myTable.delegate = nil;
}
-(void)initModel{
    [super initModel];
    selectedIndex = 0;
    self.myArray = [NSMutableArray array];
}
#pragma mark - 请求竞价房源列表
-(void)doRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/getplanprops/" params:params target:self action:@selector(onGetLogin:)];
    [self showLoadingActivity:YES];
}
- (void)onGetLogin:(RTNetworkResponse *)response {
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        return;
    }
    DLog(@"------response [%@]", [response content]);
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];

    if (([[resultFromAPI objectForKey:@"propertyList"] count] == 0 || resultFromAPI == nil)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到数据" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self.myArray removeAllObjects];
        [self.myTable reloadData];
        [self hideLoadWithAnimated:YES];
        return;
    }
    [self.myArray removeAllObjects];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"propertyList"]];
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];

}
#pragma mark - 取消竞价推广
-(void)doStopBid{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"id"], @"propId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/spreadstop/" params:params target:self action:@selector(onStopSuccess:)];
    [self showLoadingActivity:YES];
}
- (void)onStopSuccess:(RTNetworkResponse *)response {
        DLog(@"------response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        return;
    }

//    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    
    [self hideLoadWithAnimated:YES];
    [self doRequest];
    
}
//文档缺失
#pragma mark - 取消竞价推广,(取消后房源不在竞价推广组)
-(void)doCancelBid{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"id"], @"propId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/cancelplan/" params:params target:self action:@selector(onCancelSuccess:)];
    [self showLoadingActivity:YES];
}
- (void)onCancelSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        return;
    }
    [self hideLoadWithAnimated:YES];
    [self doRequest];

}
#pragma mark - 重新开始竞价推广
-(void)doRestartBid{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"id"], @"propId", @"30", @"budget", @"1.1", @"bid", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/spreadstart/" params:params target:self action:@selector(onRestartSuccess:)];
    [self showLoadingActivity:YES];
}
- (void)onRestartSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        return;
    }
    
    //    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    
    [self hideLoadWithAnimated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = indexPath.row;
    
    if([[[self.myArray objectAtIndex:selectedIndex] objectForKey:@"bidStatus"] isEqualToString:@"3"]){
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改房源信息", @"重新开始竞价", @"取消竞价推广", nil];
        action.tag = 101;
        [action showInView:self.view];
    }else{
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改房源信息", @"竞价出价及预算", @"暂停竞价推广", nil];
        action.tag = 102;
        [action showInView:self.view];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdent = @"BaseBidPropertyCell";
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
        if (buttonIndex == 0){
            AnjukeEditPropertyViewController *controller = [[AnjukeEditPropertyViewController alloc] init];
            controller.backType = RTSelectorBackTypeDismiss;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }else if (buttonIndex == 1){//重新开始竞价
            PropertyAuctionViewController *controller = [[PropertyAuctionViewController alloc] init];
            controller.proDic = [self.myArray objectAtIndex:selectedIndex];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.delegateVC = self;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:^(void){
            }];
        }else if (buttonIndex == 2){//取消竞价
            [self doCancelBid];
        }else{
            
        }
    
    }else{
        if (buttonIndex == 0){//修改房源
            AnjukeEditPropertyViewController *controller = [[AnjukeEditPropertyViewController alloc] init];
            controller.backType = RTSelectorBackTypeDismiss;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }else if (buttonIndex == 1){//调整预算
            PropertyAuctionViewController *controller = [[PropertyAuctionViewController alloc] init];
            controller.proDic = [self.myArray objectAtIndex:selectedIndex];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.delegateVC = self;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:^{
            }];
        }else if (buttonIndex == 2){//手动暂停竞价
            [self doStopBid];
        }else{
            
        }
    }

}

#pragma mark -- PrivateMethod
-(void)rightButtonAction:(id)sender{
    SalePropertyListController *controller = [[SalePropertyListController alloc] init];
    controller.backType = RTSelectorBackTypeDismiss;
    RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
