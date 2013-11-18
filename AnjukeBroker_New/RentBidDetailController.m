//
//  RentBidDetailController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/5/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentBidDetailController.h"
#import "AnjukeEditPropertyViewController.h"
#import "RTNavigationController.h"
#import "PropertyAuctionViewController.h"
#import "SalePropertyListController.h"
#import "BaseBidPropertyCell.h"
#import "LoginManager.h"

@interface RentBidDetailController ()

@end

@implementation RentBidDetailController

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
-(void)initModel{
    [super initModel];
    self.myArray = [NSMutableArray array];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic setValue:@"汤臣一品" forKey:@"title"];
    [tempDic setValue:@"3室3厅 125平 200万" forKey:@"price"];
    [tempDic setValue:@"当前排名       今日点击       出价(元)      预算余额(元)" forKey:@"string"];
    [tempDic setValue:@"   3                  100               4.0             180.00" forKey:@"stringNum"];
    [self.myArray addObject:tempDic];
    
    tempDic = [NSMutableDictionary dictionary];
    [tempDic setValue:@"东方城市花园" forKey:@"title"];
    [tempDic setValue:@"1室1厅 33平 100万" forKey:@"price"];
    [tempDic setValue:@"当前排名       今日点击       出价(元)      预算余额(元)" forKey:@"string"];
    [tempDic setValue:@"   2                  312              5.0             180.00" forKey:@"stringNum"];
    [self.myArray addObject:tempDic];
    
    tempDic = [NSMutableDictionary dictionary];
    [tempDic setValue:@"塘桥小区" forKey:@"title"];
    [tempDic setValue:@"4室2厅 78平 300万" forKey:@"price"];
    [tempDic setValue:@"当前排名       今日点击       出价(元)      预算余额(元)" forKey:@"string"];
    [tempDic setValue:@"   1                  34               2.0             32.00" forKey:@"stringNum"];
    [self.myArray addObject:tempDic];
    
    tempDic = [NSMutableDictionary dictionary];
    [tempDic setValue:@"崂山一村" forKey:@"title"];
    [tempDic setValue:@"3室1厅 66平 125万" forKey:@"price"];
    [tempDic setValue:@"当前排名       今日点击       出价(元)      预算余额(元)" forKey:@"string"];
    [tempDic setValue:@"   1                  56              2.0             24.00" forKey:@"stringNum"];
    [self.myArray addObject:tempDic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doRequest];
}
#pragma mark - 请求竞价房源列表
-(void)doRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/bid/getplanprops/" params:params target:self action:@selector(onGetLogin:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetLogin:(RTNetworkResponse *)response {
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    BidPropertyDetailController *controller = [[BidPropertyDetailController alloc] init];
    //    controller.propertyObject = [self.myArray objectAtIndex:[indexPath row]];
    //    [self.navigationController pushViewController:controller animated:YES];
    
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
    
    [cell setValueForCellByDictinary:[self.myArray objectAtIndex:[indexPath row]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
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
        
    }else{
        
    }
}

#pragma mark -- PrivateMethod
-(void)rightButtonAction:(id)sender{
    if(self.isLoading){
        return ;
    }
    SalePropertyListController *controller = [[SalePropertyListController alloc] init];
    controller.backType = RTSelectorBackTypeDismiss;
    RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
