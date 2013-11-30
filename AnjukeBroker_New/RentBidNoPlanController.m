//
//  RentBidNoPlanController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/19/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentBidNoPlanController.h"
#import "RentNoPlanListCell.h"
#import "SaleNoPlanListManager.h"
#import "RentAuctionViewController.h"
#import "RTNavigationController.h"
#import "LoginManager.h"

@interface RentBidNoPlanController ()

@end

@implementation RentBidNoPlanController
@synthesize tempDic;
@synthesize fixedObj;

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_BID_NOPLAN_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_BID_NOPLAN_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
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
	// Do any additional setup after loading the view.
}
-(void)initModel_{
    self.tempDic = [NSDictionary dictionary];
}
- (void)initDisplay_ {
    self.myTable.frame = FRAME_BETWEEN_NAV_TAB;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doRequest];
}
//#pragma mark - Request 定价推广
//-(void)doFixed{
//    if(![self isNetworkOkay]){
//        return;
//    }
//    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  @"187275101", @"proIds", @"388666", @"planId", nil];
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  [self getStringFromArray:self.sele], @"propIds", [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"fixPlanId"], @"planId", nil];
//    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/addpropstoplan/" params:params target:self action:@selector(onFixedSuccess:)];
//    [self showLoadingActivity:YES];
//    self.isLoading = YES;
//}
//
//- (void)onFixedSuccess:(RTNetworkResponse *)response {
//    DLog(@"------response [%@]", [response content]);
//    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
//        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alert show];
//        [self hideLoadWithAnimated:YES];
//        self.isLoading = NO;
//
//        return;
//    }
//    [self hideLoadWithAnimated:YES];
//    self.isLoading = NO;
//
//    RentFixedDetailController *controller = [[RentFixedDetailController alloc] init];
//    controller.backType = RTSelectorBackTypePopToRoot;
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:[[self.myArray objectAtIndex:selectedIndex] objectForKey:@"fixPlanId"] forKey:@"fixPlanId"];
//    controller.tempDic = dic;
//    [self.navigationController pushViewController:controller animated:YES];
//}
//-(NSString *)getStringFromArray:(NSArray *) array{
//    NSMutableString *tempStr = [NSMutableString string];
//    for (int i=0;i<[array count];i++) {
//        SalePropertyObject *pro = (SalePropertyObject *)[array objectAtIndex:i];
//        if(tempStr.length == 0){
//            [tempStr appendString:[NSString stringWithFormat:@"%@",pro.propertyId]];
//        }else{
//            [tempStr appendString:@","];
//            [tempStr appendString:[NSString stringWithFormat:@"%@",pro.propertyId]];
//        }
//    }
//    DLog(@"====%@",tempStr);
//    return tempStr;
//}

#pragma mark - 请求可定价房源列表
-(void)doRequest{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/getbidprops/" params:params target:self action:@selector(onGetFixedInfo:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetFixedInfo:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if([[response content] count] == 0){
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
    if([resultFromAPI count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return ;
    }
    //    NSMutableDictionary *dicPlan = [[NSMutableDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"plan"]];
    if([[resultFromAPI objectForKey:@"propertyList"] count] == 0){
//    UIAlertView *alert = [UIAlertView alloc] initWithTitle:<#(NSString *)#> message:<#(NSString *)#> delegate:<#(id)#> cancelButtonTitle:<#(NSString *)#> otherButtonTitles:<#(NSString *), ...#>, nil
    
    }
    [self.myArray removeAllObjects];
    //    [self.myArray addObject:[SaleFixedManager fixedPlanObjectFromDic:dicPlan]];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"propertyList"]];
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

#pragma mark - TableView Delegate & Datasource
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(270, 40);
//    SalePropertyObject *property = (SalePropertyObject *)[self.myArray objectAtIndex:indexPath.row];
    CGSize si = [[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return si.height+40.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}
#pragma mark - TableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"RentNoPlanListCell";
    
    RentNoPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[RentNoPlanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
    }
    [cell configureCellWithDic:[self.myArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RentAuctionViewController *controller = [[RentAuctionViewController alloc] init];
    controller.backType = RTSelectorBackTypeDismiss;
    controller.proDic = [self.myArray objectAtIndex:indexPath.row];
    controller.delegateVC = self;
    [self.navigationController pushViewController:controller animated:YES];
}


@end
