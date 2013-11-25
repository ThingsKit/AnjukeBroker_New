//
//  SalePropertyListController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SalePropertyListController.h"
#import "BasePropertyObject.h"
#import "PropertyDetailCell.h"
#import "SaleAuctionViewController.h"
#import "RTNavigationController.h"

@interface SalePropertyListController ()

@end

@implementation SalePropertyListController
@synthesize myArray;
@synthesize myTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.myArray = [NSMutableArray array];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"选择房源"];
    
    self.myTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:self.myTable];

	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doRequest];
}
#pragma mark - 请求可定价房源列表
-(void)doRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/getbidprops/" params:params target:self action:@selector(onGetFixedInfo:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetFixedInfo:(RTNetworkResponse *)response {
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
    //    NSMutableDictionary *dicPlan = [[NSMutableDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"plan"]];
    [self.myArray removeAllObjects];
    //    [self.myArray addObject:[SaleFixedManager fixedPlanObjectFromDic:dicPlan]];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"propertyList"]];
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SaleAuctionViewController *controller = [[SaleAuctionViewController alloc] init];
    controller.proDic = [self.myArray objectAtIndex:[indexPath row]];
    controller.backType = RTSelectorBackTypeDismiss;
    controller.delegateVC = self;
//    RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *cellIdent = @"PropertyDetailCell";
        PropertyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == Nil){
            cell = [[NSClassFromString(@"PropertyDetailCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PropertyDetailCell"];
        }
    [cell setValueForCellByDictionar:[self.myArray objectAtIndex:[indexPath row]]];
        return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --PrivateMethod

@end
