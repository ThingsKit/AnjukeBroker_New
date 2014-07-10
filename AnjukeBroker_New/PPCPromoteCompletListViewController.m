//
//  PPCPromoteCompletListViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-3.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "PPCPromoteCompletListViewController.h"
#import "PPCPriceingListModel.h"
#import "PropertySingleViewController.h"
#import "RTGestureLock.h"

@interface PPCPromoteCompletListViewController ()
@property(nonatomic, assign) NSInteger deleCellNum;
@property(nonatomic, assign) BOOL isLoading;
@property(nonatomic, assign) BOOL isCleanAll;
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
    self.view.backgroundColor = [UIColor brokerBgPageColor];

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

    if (self.tableData && self.tableData.count > 0) {
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
        btn.titleLabel.font = [UIFont ajkH3Font];
        [btn setTitleColor:[UIColor brokerWhiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cleanAll:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:btn];
    }
}

- (void)doBack:(id)sender{
    [super doBack:sender];
    [[BrokerLogger sharedInstance] logWithActionCode:JJTG_LIST_CLICK_BACK page:JJTG_LIST_PAGE note:nil];
}

- (void)cleanAll:(id)sender{
    self.isCleanAll = YES;
    [self cleanPromoteCompletHouse:nil];
}

- (void)cleanPromoteCompletHouse:(NSString *)propertyID{
    self.isCleanAll = NO;
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

    [[BrokerLogger sharedInstance] logWithActionCode:JJTG_LIST_CLICK_EMPTY page:JJTG_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:propIDS,@"PROP_IDS", nil]];
    
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

    [[HUDNews sharedHUDNEWS] createHUD:@"删除房源成功" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALOK];

    if (self.isCleanAll) {
        [self.tableData removeAllObjects];
        [self.tableList reloadData];
    }else{
        [self.tableData removeObjectAtIndex:self.deleCellNum];
        NSIndexPath *path = [NSIndexPath indexPathForItem:self.deleCellNum inSection:0];
        
        [self.tableList deleteRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
//    if (!self.tableData || self.tableData.count == 0) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    [self showLoadingActivity:YES];
    [self performSelector:@selector(popBack) withObject:nil afterDelay:3.0];
}

- (void)popBack{
    [self hideLoadWithAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
//    static NSString *identify = @"cell";
    PPCHouseCell *cell = (PPCHouseCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    if (!cell) {
        cell = [[PPCHouseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:nil
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PropertySingleViewController *singleVC = [[PropertySingleViewController alloc] init];
    singleVC.isHaozu = self.isHaozu;
    singleVC.propId = [self.tableData objectAtIndex:indexPath.row][@"propId"];
    singleVC.pageType = PAGE_TYPE_FIX;
    [self.navigationController pushViewController:singleVC animated:YES];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    DLog(@"didTriggerLeftUtilityButtonWithIndex-->>%d",index);
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    DLog(@"didTriggerRightUtilityButtonWithIndex-->>%d",index);
    NSIndexPath *indexPath = [self.tableList indexPathForCell:cell];

    [[BrokerLogger sharedInstance] logWithActionCode:JJTG_LIST_LEFT_DELETE page:JJTG_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[self.tableData objectAtIndex:indexPath.row][@"propId"],@"PROP_ID", nil]];
    
    self.deleCellNum = indexPath.row;
    [self cleanPromoteCompletHouse:[self.tableData objectAtIndex:indexPath.row][@"propId"]];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell nowStatus:(CellState)status{
    if (status == CellStateLeft || status == CellStateRight) {
        [RTGestureLock setDisableGestureForBack:(BK_RTNavigationController *)self.navigationController disableGestureback:YES];
    }
    if (status == CellStateCenter) {
        [RTGestureLock setDisableGestureForBack:(BK_RTNavigationController *)self.navigationController disableGestureback:NO];
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 2:{
            NSLog(@"right utility buttons open");
            NSIndexPath *path = [self.tableList indexPathForCell:cell];
            NSString *propID;
            propID = [self.tableData objectAtIndex:path.row][@"propId"];
            [self sendLeftSwipLogAndPropId:propID];
        }
            break;
        default:
            break;
    }
}

- (void)sendLeftSwipLogAndPropId:(NSString *)propId
{
    [[BrokerLogger sharedInstance] logWithActionCode:JJTG_LIST_LEFT_LA page:JJTG_LIST_PAGE note:@{@"propId":propId}];
}

- (NSMutableArray *)getMenuButton{
    NSMutableArray *btnArr = [NSMutableArray array];

    [btnArr sw_addUtilityButtonWithColor:[UIColor brokerRedColor] title:@"删除"];

    return btnArr;
}

@end
