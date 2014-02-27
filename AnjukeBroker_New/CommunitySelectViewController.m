//
//  CommunitySelectViewController.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-2-27.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CommunitySelectViewController.h"

@interface CommunitySelectViewController ()

@end

@implementation CommunitySelectViewController
@synthesize pageTypeFrom;
@synthesize arr;

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
    [self setTitleViewWithString:@"小区选择"];
    
    [self request];
}
-(void)request{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    
    NSString *urlStr;
    NSMutableDictionary *params;
    if (self.pageTypeFrom == secondHandHouse) {
        urlStr = @"anjuke/chat/getcommlist/";
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
    }else{
        urlStr = @"zufang/chat/getcommlist/";
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
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
    
    if (![resultFromAPI objectForKey:@"data"] || [[resultFromAPI objectForKey:@"data"] count] == 0) {
        [self showInfo:@"暂无数据"];
        return;
    }else{
        if (self.arr) {
            [self.arr removeAllObjects];
        }
        self.arr = [[NSMutableArray alloc] initWithArray:[resultFromAPI objectForKey:@"data"]];
        
        [self.tableList reloadData];
    }
    
    [self hideLoadWithAnimated:YES];
}

#pragma UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return COMMUNITYSELECTCELLHEIGHT;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cellName";
    houseSelectCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[houseSelectCommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell insertCellWithDic:[arr objectAtIndex:indexPath.row]];
    [cell showBottonLineWithCellHeight:COMMUNITYSELECTCELLHEIGHT];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PropertySelectViewController *ProLVC = [[PropertySelectViewController alloc] init];
    ProLVC.backType = RTSelectorBackTypePopBack;
    if (self.pageTypeFrom == secondHandHouse) {
        ProLVC.pageTypePropertyFrom = secondHandPropertyHouse;
    }else{
        ProLVC.pageTypePropertyFrom = rentPropertyHouse;
    }
    [ProLVC passDataWithDic:[self.arr objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:ProLVC animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
