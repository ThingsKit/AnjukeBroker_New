//
//  AnjukeUploadPropertyResultController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/21/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "AnjukePropertyResultController.h"
#import "SaleNoPlanListManager.h"
#import "SaleFixedManager.h"
#import "SaleNoPlanListCell.h"
#import "LoginManager.h"
#import "RentBidPropertyCell.h"
#import "RentPropertyListCell.h"
#import "SalePropertyListCell.h"

@interface AnjukePropertyResultController ()

@end

@implementation AnjukePropertyResultController
@synthesize myArray;
@synthesize myTable;
@synthesize resultType;
@synthesize planId;

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
    
	// Do any additional setup after loading the view.
    
    [self addRightButton:@"确定" andPossibleTitle:@""];
}

- (void)initModel{
    self.myArray = [NSMutableArray array];
}

- (void)initDisplay {
    [self setTitleViewWithString:@"结果页"];
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:self.myTable];
}

- (void)dealloc{
    self.myTable.delegate = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    switch (self.resultType) {
        case PropertyResultOfRentNoPlan:
            [self doRentRequest];
            break;
        case PropertyResultOfRentFixed:
            [self doRentFixedRequest];
            break;
        case PropertyResultOfRentBid:
            [self doRentBidRequest];
            break;
        case PropertyResultOfSaleNoPlan:
            [self doSaleRequest];
            break;
        case PropertyResultOfSaleFixed:
            [self doSaleFixedRequest];
            break;
        case PropertyResultOfSaleBid:
            [self doSaleBidRequest];
            break;
        default:
            break;
    }
}

#pragma mark - Private Method

- (void)doBack:(id)sender {
    if (self.isLoading) {
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightButtonAction:(id)sender {
    if (self.isLoading) {
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Request 二手房未推广列表
-(void)doSaleRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/prop/noplanprops/" params:params target:self action:@selector(onGetSaleNoPlanSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetSaleNoPlanSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }

    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    if([resultFromAPI count] ==  0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return ;
    }
    if (([[resultFromAPI objectForKey:@"propertyList"] count] == 0 || resultFromAPI == nil)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到数据" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self.myArray removeAllObjects];
        [self.myTable reloadData];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
//    NSMutableArray *result = [SaleNoPlanListManager propertyObjectArrayFromDicArray:[resultFromAPI objectForKey:@"propertyList"]];
    [self.myArray removeAllObjects];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"propertyList"]];
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
}

#pragma mark - Request 租房未推广列表
-(void)doRentRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/prop/noplanprops/" params:params target:self action:@selector(onGetRentSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetRentSuccess:(RTNetworkResponse *)response {
    
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
    if([resultFromAPI count] ==  0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return ;
    }
    if (([[resultFromAPI objectForKey:@"propertyList"] count] == 0 || resultFromAPI == nil)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到数据" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self.myArray removeAllObjects];
        [self.myTable reloadData];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
//    NSMutableArray *result = [SaleNoPlanListManager propertyObjectArrayFromDicArray:[resultFromAPI objectForKey:@"propertyList"]];
    [self.myArray removeAllObjects];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"propertyList"]];
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
}
#pragma mark - Request 请求租房竞价房源列表
-(void)doRentBidRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/bid/getplanprops/" params:params target:self action:@selector(onGetRentBidSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetRentBidSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到数据" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self.myArray removeAllObjects];
        [self.myTable reloadData];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    [self.myArray removeAllObjects];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"propertyList"]];
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}
#pragma mark - Request 请求二手房竞价房源列表
-(void)doSaleBidRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/bid/getplanprops/" params:params target:self action:@selector(onGetSaleBidSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}
- (void)onGetSaleBidSuccess:(RTNetworkResponse *)response {
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
    
    if (([[resultFromAPI objectForKey:@"propertyList"] count] == 0 || resultFromAPI == nil)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到数据" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self.myArray removeAllObjects];
        [self.myTable reloadData];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    [self.myArray removeAllObjects];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"propertyList"]];
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}
#pragma mark - Request 请求二手房定价组详情
-(void)doSaleFixedRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", self.planId, @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/getplandetail/" params:params target:self action:@selector(onGetSaleFixedInfo:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetSaleFixedInfo:(RTNetworkResponse *)response {
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
    [self.myArray removeAllObjects];
//    [self.myArray addObject:[SaleFixedManager fixedPlanObjectFromDic:dicPlan]];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"propertyList"]];
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}
#pragma mark - Request 请求租房定价组详情
-(void)doRentFixedRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", self.planId, @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/getplandetail/" params:params target:self action:@selector(onGetRentFixedInfo:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetRentFixedInfo:(RTNetworkResponse *)response {
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
    [self.myArray removeAllObjects];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"propertyList"]];
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

#pragma mark - UITableView Delegate & Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.resultType) {
        case PropertyResultOfRentNoPlan:
            return 67.0f;
            break;
        case PropertyResultOfRentFixed:
            return 85.0f;
            break;
        case PropertyResultOfRentBid:
            return 114.0f;
            break;
        case PropertyResultOfSaleNoPlan:
            return 67.0f;
            break;
        case PropertyResultOfSaleFixed:
            return 85.0f;
            break;
        case PropertyResultOfSaleBid:
            return 114.0f;
            break;
        default:
            break;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (self.resultType) {
        case PropertyResultOfRentNoPlan:
        {
            static NSString *cellIdent = @"SaleNoPlanListCell";
            
            SaleNoPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
            if(cell == nil){
                cell = [[SaleNoPlanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
            }
            [cell configureCellWithDic:[self.myArray objectAtIndex:indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case PropertyResultOfRentFixed:
        {
    static NSString *cellIdent = @"RentPropertyListCell";
    RentPropertyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[NSClassFromString(@"RentPropertyListCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RentPropertyListCell"];
        //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell configureCell:[self.myArray objectAtIndex:[indexPath row]]];
    return cell;
        }
            break;
        case PropertyResultOfRentBid:
        {
            static NSString *cellIdent = @"RentBidPropertyCell";
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
            break;
        case PropertyResultOfSaleNoPlan:
        {
            static NSString *cellIdent = @"SaleNoPlanListCell";
            
            SaleNoPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
            if(cell == nil){
                cell = [[SaleNoPlanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
            }
            [cell configureCellWithDic:[self.myArray objectAtIndex:indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case PropertyResultOfSaleFixed:
        {
    static NSString *cellIdent = @"SalePropertyListCell";
    SalePropertyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[NSClassFromString(@"SalePropertyListCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SalePropertyListCell"];
    }
    [cell configureCell:[self.myArray objectAtIndex:[indexPath row]]];
    return cell;
        }
            break;
        case PropertyResultOfSaleBid:
        {
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
            break;
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
