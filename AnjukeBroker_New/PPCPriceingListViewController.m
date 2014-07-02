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
@property(nonatomic, strong) NSMutableArray *tableData;
@property(nonatomic, strong) NSArray *lastedListData;
@property(nonatomic, strong) NSArray *oldListData;

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
    self.tableList.rowHeight = 95;
    [self.view addSubview:self.tableList];

    [self autoPullDown];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.lastedListData.count == 0 && self.oldListData.count == 0) {
        return 0;
    }
    if (self.lastedListData.count > 0 && self.oldListData.count > 0) {
        return 2;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.lastedListData.count == 0 && self.oldListData.count == 0) {
        return nil;
    }
    if (self.lastedListData.count > 0 && self.oldListData.count > 0) {
        if (section == 0) {
            return nil;
        }else if (section == 1){
            return @"30天前发布房源";
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.lastedListData.count == 0 && self.oldListData.count == 0) {
        return 0.0;
    }
    if (self.lastedListData.count > 0 && self.oldListData.count > 0) {
        if (section == 0) {
            return 0.0;
        }else if (section == 1){
            return 45.0;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    PPCHouseCell *cell = (PPCHouseCell *)[tableView dequeueReusableCellWithIdentifier:identify];
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
    if (indexPath.row != self.tableData.count - 1) {
        [cell showBottonLineWithCellHeight:95 andOffsetX:15];
    }else{
        [cell showBottonLineWithCellHeight:95 andOffsetX:0];
    }
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
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",self.planId,@"planId",[LoginManager getCity_id],@"cityId", nil];
        method = [NSString stringWithFormat:@"zufang/fix/props/"];
    }else{
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",self.planId,@"planId",[LoginManager getCity_id],@"cityId", nil]; 
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
        
        [self.tableData removeAllObjects];
        [self.tableList reloadData];
        
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        DLog(@"message--->>%@",[[response content] objectForKey:@"message"]);

        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
        
        
        [self.tableData removeAllObjects];
        [self.tableList reloadData];
        
        [self donePullDown];
        return;
    }
    self.isLoading = NO;
    [self donePullDown];
    
    NSDictionary *resultData = [NSDictionary dictionaryWithDictionary:[response content][@"data"]];
    self.tableData = nil;
    
    self.lastedListData = [NSArray arrayWithArray:resultData[@"newList"]];
    self.oldListData = [NSArray arrayWithArray:resultData[@"oldList"]];
    self.tableData = [[NSMutableArray alloc] init];
    
    if (self.lastedListData.count > 0) {
        for (int i = 0; i < self.lastedListData.count; i++) {
            [self.tableData addObject:[self.lastedListData objectAtIndex:i]];
        }
    }
    if (self.oldListData.count > 0) {
        for (int i = 0; i < self.oldListData.count; i++) {
            [self.tableData addObject:[self.oldListData objectAtIndex:i]];
        }
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
    DLog(@"didTriggerLeftUtilityButtonWithIndex-->>%d",index);
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    DLog(@"didTriggerRightUtilityButtonWithIndex-->>%d",index);
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

