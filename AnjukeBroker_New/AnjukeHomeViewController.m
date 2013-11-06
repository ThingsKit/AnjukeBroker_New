//
//  AJK_AnjukeHomeViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukeHomeViewController.h"
#import "SaleNoPlanGroupController.h"
#import "SaleFixedDetailController.h"
#import "SaleBidDetailController.h"
#import "PPCGroupCell.h"
#import "LoginManager.h"

@interface AnjukeHomeViewController ()

@end

@implementation AnjukeHomeViewController
@synthesize myTable;
@synthesize myArray;

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
    
    [self setTitleViewWithString:@"二手房"];
    
    self.myArray = [NSMutableArray array];
    self.myTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
//    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:self.myTable];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"竞价房源" forKey:@"title"];
    [dic setValue:@"房源数：10套" forKey:@"detail"];
    [dic setValue:@"" forKey:@"status"];
    [dic setValue:@"1" forKey:@"type"];
    [self.myArray addObject:dic];
    
    dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"定价房源" forKey:@"title"];
    [dic setValue:@"分组名称  房源数：10套" forKey:@"detail"];
    [dic setValue:@"推广中" forKey:@"status"];
    [dic setValue:@"2" forKey:@"type"];
    [self.myArray addObject:dic];
    
    dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"待推广房源" forKey:@"title"];
    [dic setValue:@"房源数：10套" forKey:@"detail"];
    [dic setValue:@"3" forKey:@"status"];
    [dic setValue:@"3" forKey:@"type"];
    [self.myArray addObject:dic];
    
    
	// Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor yellowColor];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doRequest];
}
-(void)doRequest{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/prop/noplanproptotal/" params:params target:self action:@selector(onGetLogin:)];

}

- (void)onGetLogin:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [[response content] JSONRepresentation]);
    DLog(@"------response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    NSString *tempDetail = [NSString stringWithFormat:@"房源数：%@套", [resultFromAPI objectForKey:@"total"]];
    NSMutableDictionary *tempDic = [myArray lastObject];
    
    [tempDic setValue:tempDetail forKey:@"detail"];
    [myArray removeLastObject];
    [myArray addObject:tempDic];
    [myTable reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if([indexPath row] == 0)
    {
        SaleBidDetailController *controller = [[SaleBidDetailController alloc] init];
        controller.backType = RTSelectorBackTypePopToRoot;
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([indexPath row] == 1){
        SaleFixedDetailController *controller = [[SaleFixedDetailController alloc] init];
        controller.backType = RTSelectorBackTypePopToRoot;
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        SaleNoPlanGroupController *controller = [[SaleNoPlanGroupController alloc] init];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    
    PPCGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[NSClassFromString(@"PPCGroupCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
    }
    
    [cell setValueForCellByDictinary:[self.myArray objectAtIndex:[indexPath row]]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//    content.backgroundColor = [UIColor lightGrayColor];
//    
//    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 50, 20)];
//    headerLab.backgroundColor = [UIColor clearColor];
//    headerLab.text = @"10";
//    [content addSubview:headerLab];
//    
//    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 320, 20)];
//    headerLab.text = @"在线房源";
//    [content addSubview:headerLab];
//    
//    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 50, 20)];
//    headerLab.text = @"100";
//    [content addSubview:headerLab];
//    
//    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(120, 45, 320, 20)];
//    headerLab.text = @"今日已点击";
//    [content addSubview:headerLab];
//    
//    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(230, 10, 50, 20)];
//    headerLab.text = @"99.0";
//    [content addSubview:headerLab];
//    
//    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(220, 45, 320, 20)];
//    headerLab.text = @"今日花费(元)";
//    [content addSubview:headerLab];
//    
//    return content;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 100;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
