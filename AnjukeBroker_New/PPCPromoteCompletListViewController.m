//
//  PPCPromoteCompletListViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-3.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PPCPromoteCompletListViewController.h"
#import "PPCPriceingListModel.h"

@interface PPCPromoteCompletListViewController ()
@property(nonatomic, assign) NSInteger deleCellNum;
@property(nonatomic, assign) BOOL isLoading;
@end

@implementation PPCPromoteCompletListViewController

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
    
    [[BrokerLogger sharedInstance] logWithActionCode:JJTG_LIST_ONVIEW page:JJTG_LIST_PAGE note:nil];
    
    if (self.isHaozu) {
        [self setTitleViewWithString:@"租房精选-推广结束"];
    }else{
        [self setTitleViewWithString:@"二手房精选-推广结束"];
    }

    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.backgroundColor = [UIColor clearColor];
    self.tableList.rowHeight = 95;
    [self.view addSubview:self.tableList];

    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:50];
    self.tableList.contentInset = insets;

    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50 - 20 -44, ScreenWidth, 50)];
    [buttonView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    [self.view addSubview:buttonView];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth/2 - 45, 8, 90, 33);
    [btn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_little_blue"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [btn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_little_blue_press"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [btn setTitle:@"清空" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor brokerWhiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cleanAll:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:btn];
}

- (void)doBack:(id)sender{
    [super doBack:sender];
    [[BrokerLogger sharedInstance] logWithActionCode:JJTG_LIST_CLICK_BACK page:JJTG_LIST_PAGE note:nil];
}

- (void)cleanAll:(id)sender{
    [[BrokerLogger sharedInstance] logWithActionCode:JJTG_LIST_CLICK_EMPTY page:JJTG_LIST_PAGE note:nil];

    [self cleanPromoteCompletHouse:nil];
}

- (void)cleanPromoteCompletHouse:(NSString *)propertyID{

    if (self.tableData.count == 0) {
        return;
    }

    self.isLoading = YES;
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        self.isLoading = NO;
        return;
    }
    //更新房源信息
    NSMutableDictionary *params = nil;
    NSString *method = nil;

    NSString *propIDS;

    if (!propertyID) {
        for (int i = 0; i < self.tableData.count; i++) {
            if (i == 0) {
                propIDS = [self.tableData objectAtIndex:0][@"propId"];
            }else{
                [propIDS stringByAppendingString:[NSString stringWithFormat:@",%@",[[self.tableData objectAtIndex:i] objectForKey:@"propId"]]];
            }
        }
    }else{
        propIDS = propertyID;
    }


    if (self.isHaozu) {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys: [LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", propIDS, @"propIds", nil];
        method = @"zufang/choice/delete/";
    }else {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID], @"brokerId", propIDS, @"propIds", nil];
        method = @"anjuke/choice/delete/";
    }

    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onCleanFinished:)];
}

- (void)onCleanFinished:(RTNetworkResponse *)response {
    DLog(@"--delete Prop。。。response [%@]/[%@]", [response content],[response content][@"message"]);
    if([[response content] count] == 0 || ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"])){
        self.isLoading = NO;

        [[HUDNews sharedHUDNEWS] createHUD:@"服务器开溜了" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }

    [[HUDNews sharedHUDNEWS] createHUD:@"清空房源成功" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALOK];

    [self.tableData removeAllObjects];
    [self.tableList reloadData];
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = UIEdgeInsetsZero;

    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = self.topLayoutGuide.length;
    }else {
        insets.top = 0;
    }

    insets.bottom = bottom;

    return insets;
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.tableData) {
        return 0;
    }
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

    [cell configureCell:model withIndex:indexPath.row isHaoZu:self.isHaozu];
    if (indexPath.row != self.tableData.count - 1) {
        [cell showBottonLineWithCellHeight:95 andOffsetX:15];
    }else{
        [cell showBottonLineWithCellHeight:95 andOffsetX:0];
    }
    return cell;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    DLog(@"didTriggerLeftUtilityButtonWithIndex-->>%d",index);
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    DLog(@"didTriggerRightUtilityButtonWithIndex-->>%d",index);
    [[BrokerLogger sharedInstance] logWithActionCode:JJTG_LIST_LEFT_DELETE page:JJTG_LIST_PAGE note:nil];
    
    NSIndexPath *indexPath = [self.tableList indexPathForCell:cell];
    self.deleCellNum = indexPath.row;
    [self cleanPromoteCompletHouse:[self.tableData objectAtIndex:indexPath.row][@"propId"]];
}

//删除房源
- (void)doDeleteProperty:(NSString *)propertyID
{
    self.isLoading = YES;
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        self.isLoading = NO;
        return;
    }
    //更新房源信息
    NSMutableDictionary *params = nil;
    NSString *method = nil;

    if (self.isHaozu) {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getCity_id], @"cityId", [LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", propertyID, @"propIds", nil];
        method = @"zufang/prop/delprops/";
    }
    else {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", propertyID, @"propIds", nil];
        method = @"anjuke/prop/delprops/";
    }

    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onDeletePropFinished:)];
}

- (void)onDeletePropFinished:(RTNetworkResponse *)response {
    DLog(@"--delete Prop。。。response [%@]", [response content]);

    if([[response content] count] == 0){
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
    }

    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;

        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];

        //        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        return;
    }

    [[HUDNews sharedHUDNEWS] createHUD:@"删除房源成功" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALOK];

    [self.tableData removeObjectAtIndex:self.deleCellNum];
    NSIndexPath *path = [NSIndexPath indexPathForItem:self.deleCellNum inSection:0];

    [self.tableList deleteRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationLeft];
}

- (NSMutableArray *)getMenuButton{
    NSMutableArray *btnArr = [NSMutableArray array];

    [btnArr sw_addUtilityButtonWithColor:[UIColor brokerRedColor] title:@"删除"];

    return btnArr;
}

@end
