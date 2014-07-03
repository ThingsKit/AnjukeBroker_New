//
//  PPCSelectedListViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-2.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PPCSelectedListViewController.h"
#import "RTListCell.h"
#import "PPCSelectedListCell.h"
#import "PPCPriceingListModel.h"
#import "PPCPromoteCompletListViewController.h"

@interface PPCSelectedListViewController ()
@property(nonatomic, strong) NSMutableArray *tableData;
@property(nonatomic, strong) NSMutableArray *onSpreadListData;
@property(nonatomic, strong) NSMutableArray *onQueueListData;
@property(nonatomic, strong) NSMutableArray *onOfflineListData;
@property(nonatomic, assign) BOOL isLoading;
@end

@implementation PPCSelectedListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableData = [[NSMutableArray alloc] init];
        self.onSpreadListData = [[NSMutableArray alloc] init];
        self.onQueueListData = [[NSMutableArray alloc] init];
        self.onOfflineListData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitleViewWithString:@"精选推广"];

    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableList];
    
    [self autoPullDown];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.tableData.count == 0 && self.onOfflineListData.count == 0) {
        return 0;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tableData.count == 0 && self.onOfflineListData.count == 0) {
        return 0;
    }else {
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return self.onSpreadListData.count;
        }else if (section == 2){
            return self.onQueueListData.count;
        }else if (section == 3){
//            if (self.onOfflineListData.count == 0) {
//                return 0;
//            }else{
//                return 2;
//            }
            return 2;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 40;
        }
    }
    
//    if (self.onOfflineListData.count > 0) {
    if (self.onOfflineListData.count == 0 && indexPath.section == 3) {
        if (indexPath.row == 1){
            return 45;
        }else if (indexPath.row == 0){
            return 15;
        }
    }
    return 95;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.tableData.count == 0) {
        return nil;
    }
    if (section == 0) {
        return nil;
    }else if (section == 1){
        return @"推广中";
    }else if (section == 2){
        return @"排队中";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.onSpreadListData.count == 0) {
        if (section == 1) {
            return 0;
        }
    }else if (self.onSpreadListData.count > 0){
        if (section == 1) {
            return 30;
        }
    }

    if (self.onSpreadListData.count == 0) {
        if (section == 1) {
            return 0;
        }
    }else if (self.onSpreadListData.count > 0){
        if (section == 1) {
            return 30;
        }
    }
    
    if (section == 3) {
        return 0;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify1 = @"cell1";
    static NSString *identify2 = @"cell1";
    
    if (indexPath.section == 0) {
        RTListCell *cell = (RTListCell *)[tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[RTListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
        }
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 40)];
            lab.textAlignment = NSTextAlignmentLeft;
            lab.textColor = [UIColor brokerMiddleGrayColor];
            lab.font = [UIFont ajkH4Font];
            lab.text = @"精选房源提升8倍效果";
            lab.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:lab];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(185, 0, 120, 40);
            btn.titleLabel.font = [UIFont ajkH4Font];
            [btn addTarget:self action:@selector(goSelectIntro:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"什么是精选房源?" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor brokerBlueColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor brokerBlueGrayColor] forState:UIControlStateHighlighted];
            [cell.contentView addSubview:btn];
        }
        return cell;
    }
    
//    if (self.onOfflineListData.count > 0) {
    if (self.onOfflineListData.count == 0 && indexPath.section == 3) {
        RTListCell *cell = (RTListCell *)[tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[RTListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
        }
        if (indexPath.row == 0){
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row == 1){
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            NSString *str;
            if (!self.onOfflineListData || self.onOfflineListData.count == 0) {
                str = @"推广结束";
            }else{
                str = [NSString stringWithFormat:@"推广结束(%d)",self.onOfflineListData.count];
            }
            
            cell.textLabel.text = str;
            cell.textLabel.textColor = [UIColor brokerBlackColor];
            [cell showTopLine];
            [cell showBottonLineWithCellHeight:45];
        }
        return cell;
    }

    PPCSelectedListCell *cell = (PPCSelectedListCell *)[tableView dequeueReusableCellWithIdentifier:identify2];
    if (!cell) {
        cell = [[PPCSelectedListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
    }
    PPCPriceingListModel *model = [PPCPriceingListModel convertToMappedObject:[self.tableData objectAtIndex:indexPath.row]];
    [cell configureCell:model withIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        [cell showTopLine];
    }
    
    if (self.onSpreadListData.count > 0) {
        if (indexPath.row == self.onSpreadListData.count - 1) {
            [cell showBottonLineWithCellHeight:95 andOffsetX:0];
        }else{
            [cell showBottonLineWithCellHeight:95 andOffsetX:15];
        }
    }
    if (self.onQueueListData.count > 0) {
        if (indexPath.row == self.onQueueListData.count - 1) {
            [cell showBottonLineWithCellHeight:95 andOffsetX:0];
        }else{
            [cell showBottonLineWithCellHeight:95 andOffsetX:15];
        }
    }
    
    return cell;
}

- (void)goSelectIntro:(id)sender{
    
}

- (void)doRequest{
    self.isLoading = YES;
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    if (self.isHaozu) {
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId", nil];

        method = [NSString stringWithFormat:@"zufang/choice/props/"];
    }else{
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId",@"0",@"demon", nil];
        
        method = [NSString stringWithFormat:@"anjuke/choice/props/"];
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
        DLog(@"message--->>%@",[[response content] objectForKey:@"message"]);
        
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
    [self donePullDown];
    self.isLoading = NO;
    
    NSDictionary *resultApi = [NSDictionary dictionaryWithDictionary:[response content][@"data"]];
    self.tableData = nil;
    self.tableData = [[NSMutableArray alloc] init];
    
    if (resultApi[@"OnlinePropertyList"]) {
        self.onSpreadListData = resultApi[@"OnlinePropertyList"];
    }
    if (resultApi[@"QueuedPropertyList"]) {
        self.onQueueListData = resultApi[@"QueuedPropertyList"];
    }
    if (resultApi[@"OfflinePropertyList"]) {
        self.onOfflineListData = resultApi[@"OfflinePropertyList"];
    }
    
    
    [self.tableData addObjectsFromArray:self.onSpreadListData];
    [self.tableData addObjectsFromArray:self.onQueueListData];

    
    if (self.tableData.count == 0) {
        [self.tableList setTableStatus:STATUSFORNODATAFORPRICINGLIST];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
    }
    
    [self.tableList reloadData];
}

- (void)tapGus:(UITapGestureRecognizer *)tap{
    [self autoPullDown];
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.tableData || self.navigationController.view.frame.origin.x > 0) {
        return;
    }
    
//    if (self.onOfflineListData.count > 0 && indexPath.section == 3 && indexPath.row == 1) {
    if (self.onOfflineListData.count == 0 && indexPath.section == 3 && indexPath.row == 1) {
        PPCPromoteCompletListViewController *promoteCompletListVC = [[PPCPromoteCompletListViewController alloc] init];
        promoteCompletListVC.isHaozu = self.isHaozu;
        promoteCompletListVC.tableData = self.onSpreadListData;
        [self.navigationController pushViewController:promoteCompletListVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

