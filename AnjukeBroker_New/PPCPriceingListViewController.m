//
//  PPCPriceingListViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PPCPriceingListViewController.h"
#import "PPCHouseCell.h"
#import "NSMutableArray+SWUtilityButtons.h"
#import "PPCPriceingListModel.h"

@interface PPCPriceingListViewController ()
@property(nonatomic, strong) NSArray *tableData;
@property(nonatomic, assign) BOOL isLoading;
@end

@implementation PPCPriceingListViewController

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
    
    [self setTitleViewWithString:@"定价推广"];
    [self addRightButton:@"发布" andPossibleTitle:nil];

    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableList];

    [self autoPullDown];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    PPCHouseCell *cell = (PPCHouseCell *)[tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    if (!cell) {
        cell = [[PPCHouseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:identify
                               containingTableView:tableView
                                leftUtilityButtons:nil
                               rightUtilityButtons:[self getMenuButton]];
        cell.delegate = self;
    }
    
    
    PPCPriceingListModel *model = [PPCPriceingListModel convertToMappedObject:[self.tableData objectAtIndex:indexPath.row]];
    
    [cell configureCell:model withIndex:indexPath.row];
    return cell;
}

- (NSMutableArray *)getMenuButton{
    NSMutableArray *btnArr = [NSMutableArray array];
    
    [btnArr sw_addUtilityButtonWithColor:[UIColor brokerLineColor] title:@"编辑"];
    [btnArr sw_addUtilityButtonWithColor:[UIColor brokerRedColor] title:@"删除"];
    
    return btnArr;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.tableData || self.navigationController.view.frame.origin.x > 0) {
        return;
    }
}

- (void)doRequest{
    self.isLoading = YES;
    NSMutableDictionary *params = nil;
    NSString *method = nil;

    if (self.isHaozu) {
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getUserID],@"brokerId",self.planId,@"planId",[LoginManager getCity_id],@"cityId", nil];
//        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"3759",@"brokerId",@"164558",@"planId",@"11",@"cityId", nil];
       
        method = [NSString stringWithFormat:@"zufang/fix/props/"];
    }else{
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",self.planId,@"planId",[LoginManager getCity_id],@"cityId", nil];
//        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",@"3759",@"brokerId",@"164558",@"planId",@"11",@"cityId", nil];
 
        method = [NSString stringWithFormat:@"anjuke/fix/props/"];
    }

    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];

}
- (void)onRequestFinished:(RTNetworkResponse *)response{
    self.isLoading = NO;
    DLog(@"response---->>%@",[response content]);
    if([[response content] count] == 0){
        [self donePullDown];
        [self.tableList setTableStatus:STATUSFORNODATAFORPRICINGLIST];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
        
        
        self.tableData = nil;
        [self.tableList reloadData];
        
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
        
        
        self.tableData = nil;
        [self.tableList reloadData];
        
        [self donePullDown];
        return;
    }
    
    NSArray *arr = [NSArray arrayWithArray:[response content][@"data"]];
    if (arr.count >= 1) {
        self.tableData = [NSArray arrayWithArray:[response content][@"data"][@"propertyList"]];
    }else{
        [self donePullDown];
        
        self.tableData = nil;
        [self.tableList reloadData];
        [self.tableList setTableStatus:STATUSFORNODATAFORPRICINGLIST];
    }
    
    if (self.tableData.count == 0) {
        [self.tableList setTableStatus:STATUSFORNODATAFORPRICINGLIST];
    }else{
        [self.tableList setTableStatus:STATUSFOROK];
    }
    
    [self.tableList reloadData];
}
- (void)rightButtonAction:(id)sender{
    
}

- (void)tapGus:(UITapGestureRecognizer *)tap{
    [self autoPullDown];
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {

}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

