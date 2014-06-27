//
//  PropertySelectViewController.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-2-27.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PropertySelectViewController.h"
#import "HouseSelectNavigationController.h"

@interface PropertySelectViewController ()

@end

@implementation PropertySelectViewController
@synthesize pageTypePropertyFrom;
@synthesize commDic;
@synthesize arr;
#pragma mark - log
- (void)sendAppearLog {
    if (self.pageTypePropertyFrom == secondHandPropertyHouse){
        if (_isSayHello)
        {
            [[BrokerLogger sharedInstance] logWithActionCode:POTENTIAL_CLIENT_PROP_ONVIEW page:POTENTIAL_CLIENT_PROP note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
        }else
        {
            [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ESF_PROP_ONVIEW page:CHAT_ESF_PROP note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
        }
        
    }else {
        [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ZF_PROP_ONVIEW page:CHAT_ZF_PROP note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    }
}

- (void)sendDisAppearLog {
    if (self.pageTypePropertyFrom == secondHandPropertyHouse){
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_PROPERTY_CHAT_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    }else {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_PROPERTY_CHAT_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    }
}

#pragma mark - lifeCycle
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
    [self setTitleViewWithString:@"房源选择"];

    [self request];
}
-(void)request{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    
    NSString *urlStr;
    NSMutableDictionary *params;
    if (self.pageTypePropertyFrom == secondHandPropertyHouse){
        urlStr = @"anjuke/chat/getcommprops/";
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId",[commDic objectForKey:@"commId"],@"commId", nil];
    }else{
        urlStr = @"zufang/chat/getcommprops/";
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId",[commDic objectForKey:@"commId"],@"commId", nil];
    }
    
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:urlStr params:params target:self action:@selector(onGetFixedInfo:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}
-(void)onGetFixedInfo:(RTNetworkResponse *)response{
    self.isLoading = NO;
    
    if([[response content] count] == 0){
        [self showInfo:@"操作失败"];
        [self hideLoadWithAnimated:YES];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        return;
    }
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[response content]];
    
    if (![[resultFromAPI objectForKey:@"data"] objectForKey:@"propertyList"] || [[[resultFromAPI objectForKey:@"data"]  objectForKey:@"propertyList"] count] == 0) {
        [self showInfo:@"暂无推广中房源"];
        [self hideLoadWithAnimated:YES];
        return;
    }else{
        if (self.arr) {
            [self.arr removeAllObjects];
        }
        self.arr = [[NSMutableArray alloc] initWithArray:[[resultFromAPI objectForKey:@"data"] objectForKey:@"propertyList"]];
        
        [self.tableList reloadData];
    }

    [self hideLoadWithAnimated:YES];
}
-(void)passDataWithDic:(NSDictionary *)dic{
    self.commDic = [[NSDictionary alloc] initWithDictionary:dic];
}
#pragma UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cellName";

    PropertyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[PropertyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [cell setValueForCellByDictionar:[self.arr objectAtIndex:indexPath.row]];
    
    [cell showBottonLineWithCellHeight:86.f andOffsetX:15];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pageTypePropertyFrom == secondHandPropertyHouse){
        if (_isSayHello)
        {
            [[BrokerLogger sharedInstance] logWithActionCode:POTENTIAL_CLIENT_PROP_SELECT page:POTENTIAL_CLIENT_PROP note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
        }else
        {
            [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ESF_PROP_SELECT page:CHAT_ESF_PROP note:nil];;
        }
        
    }else {
        [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ZF_PROP_SELECT page:CHAT_ZF_PROP note:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[(HouseSelectNavigationController *)self.navigationController selectedHouseDelgate] returnSelectedHouseDic:[self.arr objectAtIndex:indexPath.row] houseType:self.pageTypePropertyFrom == secondHandPropertyHouse ? YES : NO];

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ([[(HouseSelectNavigationController *)self.navigationController selectedHouseDelgate] respondsToSelector:@selector(returnSelectedHouseDic:houseType:)]) {
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)doBack:(id)sender {
    if (self.pageTypePropertyFrom == secondHandPropertyHouse){
        if (_isSayHello)
        {
            
            NSDictionary *dict = @{ @"propid":_willsendProp.propid,
                                    @"customer_udid2": _willsendProp.udid2,
                                    @"customer_macid": _willsendProp.macid,
                                    @"customer_i": _willsendProp.i,
                                    @"customer_app": _willsendProp.app};
            [[BrokerLogger sharedInstance] logWithActionCode:POTENTIAL_CLIENT_PROP_BACK page:POTENTIAL_CLIENT_PROP note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", dict, @"cst_param", nil]];
        }else
        {
            [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ESF_PROP_BACK page:CHAT_ESF_PROP note:nil];

        }
        
    }else {
        [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ZF_PROP_BACK page:CHAT_ZF_PROP note:nil];
    }
    [super doBack:self];
}
@end
