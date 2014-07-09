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
#import "CheckoutWebViewController.h"
#import "PropertySingleViewController.h"
#import "CommunityListViewController.h"
#import "RTGestureBackNavigationController.h"

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

- (void)viewWillAppear:(BOOL)animated{
    if (self.tableList && !self.isLoading) {
        [self autoPullDown];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brokerBgPageColor];

    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_JXTG_LIST_ONVIEW page:ZF_JXTG_LIST_PAGE note:nil];
    }else{
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_JX_LIST_ONVIEW page:ESF_JX_LIST_PAGE note:nil];
    }
    
    // Do any additional setup after loading the view.
    
    if (self.isHaozu) {
        [self setTitleViewWithString:@"租房-精选推广"];
    }else{
        [self setTitleViewWithString:@"二手房-精选推广"];
    }
    
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
            return 2;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 40;
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 1){
            return 45;
        }else if (indexPath.row == 0){
            return 15;
        }
    }
    return 95;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    float height;
    NSString *tit;
    if (self.onSpreadListData.count == 0) {
        if (section == 1) {
            height =  0;
        }
    }else if (self.onSpreadListData.count > 0){
        if (section == 1) {
            height = 30;
        }
    }
    
    if (self.onQueueListData.count == 0) {
        if (section == 2) {
            height =  0;
        }
    }else if (self.onQueueListData.count > 0){
        if (section == 2) {
            height = 30;
        }
    }
    
    if (section == 3) {
        height = 0;
    }
    
    if (self.tableData.count == 0) {
        tit = @"";
    }else{
        if (section == 0) {
            tit = @"";
        }else if (section == 1){
            tit = @"推广中";
        }else if (section == 2){
            tit = @"排队中";
        }else{
            tit = @"";
        }
    }

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, height)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor brokerLightGrayColor];
    lab.font = [UIFont ajkH3Font];
    lab.text = tit;
    [view addSubview:lab];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.tableData.count == 0 && self.onOfflineListData.count == 0) {
        return 0;
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

    if (self.onQueueListData.count == 0) {
        if (section == 2) {
            return 0;
        }
    }else if (self.onQueueListData.count > 0){
        if (section == 2) {
            return 30;
        }
    }
    
    if (section == 3) {
        return 0;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identify1 = @"cell1";
//    static NSString *identify2 = @"cell2";

    static NSString *identify1 = nil;
    static NSString *identify2 = nil;

    if (indexPath.section == 0 && indexPath.row == 0) {
        RTListCell *cell = (RTListCell *)[tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[RTListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [cell showBottonLineWithCellHeight:40];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 40)];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = [UIColor brokerMiddleGrayColor];
        lab.font = [UIFont ajkH4Font];
        lab.text = @"精选房源提升8倍效果";
        lab.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lab];
        
        //            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //            btn.frame = CGRectMake(185, 0, 120, 40);
        //            btn.titleLabel.font = [UIFont ajkH4Font];
        //            [btn addTarget:self action:@selector(goSelectIntro:) forControlEvents:UIControlEventTouchUpInside];
        //            [btn setTitle:@"什么是精选房源?" forState:UIControlStateNormal];
        //            [btn setTitleColor:[UIColor brokerBlueColor] forState:UIControlStateNormal];
        //            [btn setTitleColor:[UIColor brokerBlueGrayColor] forState:UIControlStateHighlighted];
        //            [cell.contentView addSubview:btn];
        return cell;
    }
    
    if (indexPath.section == 3) {
        RTListCell *cell = (RTListCell *)[tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[RTListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
        }
        if (indexPath.row == 0){
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row == 1){
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
            view.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:view];
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel *lab =[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 45)];
            lab.backgroundColor = [UIColor clearColor];
            
            NSString *str;
            if (!self.onOfflineListData || self.onOfflineListData.count == 0) {
                str = @"推广结束(0)";
            }else{
                str = [NSString stringWithFormat:@"推广结束(%d)",self.onOfflineListData.count];
            }
            
            lab.text = str;
            lab.textColor = [UIColor brokerMiddleGrayColor];
            lab.font = [UIFont ajkH3Font];
            [cell.contentView addSubview:lab];
            
            [cell showTopLine];
            [cell showBottonLineWithCellHeight:45];
        }
        return cell;
    }

    PPCSelectedListCell *cell = (PPCSelectedListCell *)[tableView dequeueReusableCellWithIdentifier:identify2];
    if (!cell) {
        cell = [[PPCSelectedListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
    }
    
    if (indexPath.section == 1) {
        PPCPriceingListModel *model = [PPCPriceingListModel convertToMappedObject:[self.onSpreadListData objectAtIndex:indexPath.row]];
        [cell configureCell:model withIndex:indexPath.row isHaoZu:self.isHaozu];
    }else if (indexPath.section == 2){
        PPCPriceingListModel *model = [PPCPriceingListModel convertToMappedObject:[self.onQueueListData objectAtIndex:indexPath.row]];
        [cell configureCell:model withIndex:indexPath.row isHaoZu:self.isHaozu];
    }
    
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

#pragma mark - method
- (void)doBack:(id)sender{
    [super doBack:sender];
    
    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_JXTG_LIST_ONVIEW page:ZF_JXTG_LIST_PAGE note:nil];
    }else{
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_JX_LIST_CLICK_BACK page:ESF_JX_LIST_PAGE note:nil];
    }
}

- (void)goSelectIntro:(id)sender{
    CheckoutWebViewController *webVC = [[CheckoutWebViewController alloc] init];
    webVC.webTitle = @"精选房源";
    webVC.webUrl = [NSString stringWithFormat:@"http://pages.anjuke.com/choice/ajkindex.html?city_id=%@",[LoginManager getCity_id]];
    
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)doRequest{
    if (![self isNetworkOkayWithNoInfo]) {
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];

        self.onSpreadListData = nil;
        self.onQueueListData = nil;
        self.onOfflineListData = nil;
        
        [self.tableList reloadData];
        
        return;
    }
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
    if(([[response content] count] == 0) || ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"])){
        [self donePullDown];
        [self.tableList setTableStatus:STATUSFORREMOTESERVERERROR];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
        
        self.tableData = nil;
        [self.tableList reloadData];
        
        return ;
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
    
    if (self.tableData.count == 0 && self.onOfflineListData.count == 0) {
        [self.tableList setTableStatus:STATUSFORNODATAFOSELECTLIST];
        
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
    DLog(@"click---->>%d",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.navigationController.view.frame.origin.x > 0) {
        return;
    }
    if (self.isLoading) {
        return;
    }
    if (indexPath.section == 3 && indexPath.row == 1) {
        if (self.isHaozu) {
            [[BrokerLogger sharedInstance] logWithActionCode:ZF_JXTG_LIST_END_TGFY page:ZF_JXTG_LIST_PAGE note:nil];
        }else{
            [[BrokerLogger sharedInstance] logWithActionCode:ESF_JX_LIST_END_JFYID page:ESF_JX_LIST_PAGE note:nil];
        }
        
        PPCPromoteCompletListViewController *promoteCompletListVC = [[PPCPromoteCompletListViewController alloc] init];
        promoteCompletListVC.isHaozu = self.isHaozu;
        promoteCompletListVC.tableData = self.onOfflineListData;
        promoteCompletListVC.forbiddenEgo = YES;
        [self.navigationController pushViewController:promoteCompletListVC animated:YES];
    }
    
    if (indexPath.section == 1 || indexPath.section == 2) {
        NSString *properID;
        if (indexPath.section == 1) {
            properID = [self.onSpreadListData objectAtIndex:indexPath.row][@"propId"];
        }else if (indexPath.section == 2){
            properID = [self.onQueueListData objectAtIndex:indexPath.row][@"propId"];
        }
        
        PropertySingleViewController *singleVC = [[PropertySingleViewController alloc] init];
        singleVC.isHaozu = self.isHaozu;
        singleVC.propId = properID;
        singleVC.pageType = PAGE_TYPE_CHOICE;
        [self.navigationController pushViewController:singleVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

