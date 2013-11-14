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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        return;
    }
    DLog(@"------response [%@]", [response content]);
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    
    if (([[resultFromAPI objectForKey:@"planProp"] count] == 0 || resultFromAPI == nil)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到数据" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self.myArray removeAllObjects];
        [self.myTable reloadData];
        [self hideLoadWithAnimated:YES];
        return;
    }
    [self.myArray removeAllObjects];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"planProp"]];
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];

}
-(void)doCancelBid{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"propId"], @"propId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/cancelplan/" params:params target:self action:@selector(onCancelSuccess:)];
    [self showLoadingActivity:YES];
}
- (void)onCancelSuccess:(RTNetworkResponse *)response {
        DLog(@"------response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        return;
    }

//    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    
    [self hideLoadWithAnimated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = indexPath.row;
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改房源信息", @"竞价出价及预算", @"暂停竞价推广", nil];
    [action showInView:self.view];

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
//    [cell setValueForCellByDictinary:[self.myArray objectAtIndex:[indexPath row]]];
    
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
    if (buttonIndex == 0){
        AnjukeEditPropertyViewController *controller = [[AnjukeEditPropertyViewController alloc] init];
        controller.backType = RTSelectorBackTypeDismiss;
        RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (buttonIndex == 1){
        PropertyAuctionViewController *controller = [[PropertyAuctionViewController alloc] init];
        controller.backType = RTSelectorBackTypeDismiss;
        controller.delegateVC = self;
        RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (buttonIndex == 2){
        [self doCancelBid];
    }else{
    
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
