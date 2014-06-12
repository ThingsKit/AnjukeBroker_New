//
//  RentGroupListController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/19/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentGroupListController.h"
#import "SaleFixedDetailController.h"
#import "RentFixedDetailController.h"
#import "LoginManager.h"
#import "PPCGroupCell.h"
#import "SalePropertyObject.h"

@interface RentGroupListController ()
{
    int selectedIndex;
}
@end

@implementation RentGroupListController
@synthesize tempArray;

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_GROUP_LIST_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_GROUP_LIST_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tempArray = [NSArray array];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)initModel{
    [super initModel];
    selectedIndex = 0;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doRentFixedGroupList];
}

#pragma mark - Request 获取定价推广组列表
-(void)doRentFixedGroupList{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/getplans/" params:params target:self action:@selector(onFixedGroupSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onFixedGroupSuccess:(RTNetworkResponse *)response {
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
    
    DLog(@"------response [%@]", [response content]);
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    if([resultFromAPI count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return ;
    }
    [self.myArray removeAllObjects];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"planList"]];
    [self.myTable reloadData];
}


#pragma mark - Request 定价推广
-(void)doFixed{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }

    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  @"187275101", @"proIds", @"388666", @"planId", nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  [self getStringFromArray:self.propertyArray], @"propIds", [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/addpropstoplan/" params:params target:self action:@selector(onFixedSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onFixedSuccess:(RTNetworkResponse *)response {
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

    RentFixedDetailController *controller = [[RentFixedDetailController alloc] init];
    controller.backType = RTSelectorBackTypePopToRoot;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[[self.myArray objectAtIndex:selectedIndex] objectForKey:@"fixPlanId"] forKey:@"fixId"];
    controller.tempDic = dic;
    [self.navigationController pushViewController:controller animated:YES];
}
-(NSString *)getStringFromArray:(NSArray *) array{
    NSMutableString *tempStr = [NSMutableString string];
    for (int i=0;i<[array count];i++) {
        SalePropertyObject *pro = (SalePropertyObject *)[array objectAtIndex:i];
        if(tempStr.length == 0){
            [tempStr appendString:[NSString stringWithFormat:@"%@",pro.propertyId]];
        }else{
            [tempStr appendString:@","];
            [tempStr appendString:[NSString stringWithFormat:@"%@",pro.propertyId]];
        }
    }
    DLog(@"====%@",tempStr);
    return tempStr;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_GROUP_LIST_004 note:nil];
    selectedIndex = indexPath.row;
    [self doFixed];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    tableView.separatorColor = [UIColor lightGrayColor];
    static NSString *cellIdent = @"PPCGroupCell";
    
    PPCGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[NSClassFromString(@"PPCGroupCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
    }
    [cell setFixedGroupValueForCellByData:self.myArray index:indexPath.row isAJK:NO];
//    [cell setFixedGroupValueForCellByData:self.myArray index:indexPath.row];
    [cell showBottonLineWithCellHeight:66.f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)doBack:(id)sender{
    [super doBack:self];
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_GROUP_LIST_003 note:nil];
}
@end
