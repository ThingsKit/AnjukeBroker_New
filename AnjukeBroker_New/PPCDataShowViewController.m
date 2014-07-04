//
//  PPCDataShowViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PPCDataShowViewController.h"
#import "PPCDataShowCell.h"
#import "PPCPriceingListViewController.h"
#import "PPCSelectedListViewController.h"
#import "HZWaitingForPromotedViewController.h"
#import "ESFWaitingForPromotedViewController.h"
#import "PPCDataShowModel.h"
#import "CommunityListViewController.h"
#import "RTGestureBackNavigationController.h"

@interface PPCDataShowViewController ()
@property(nonatomic, strong) NSMutableDictionary *pricingDic;
@property(nonatomic, strong) NSMutableDictionary *selectedDic;
@property(nonatomic, assign) BOOL isLoading;
@end

@implementation PPCDataShowViewController
@synthesize isHaozu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.pricingDic = [[NSMutableDictionary alloc] init];
        self.selectedDic = [[NSMutableDictionary alloc] init];
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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    
    if (self.isHaozu) {
        [self setTitleViewWithString:@"租房"];
    }else{
        [self setTitleViewWithString:@"二手房"];
    }
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
    if (!self.pricingDic && !self.selectedDic) {
        return 0;
    }
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 3) {
        return 15;
    }else if (indexPath.row == 1 || indexPath.row == 2){
        return 150;
    }else if (indexPath.row == 4){
        return 45;
    }else{
        return 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify1 = @"cell1";
    static NSString *identify2 = @"cell2";
    
    if (indexPath.row == 1 || indexPath.row == 2) {
        PPCDataShowCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[PPCDataShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
        }
        if (indexPath.row == 1) {
            [cell showTopLine];
            cell.isPricing = YES;
            [cell showBottonLineWithCellHeight:150 andOffsetX:15];
            
            PPCDataShowModel *model = [PPCDataShowModel convertToMappedObject:self.pricingDic];
            [cell configureCell:model withIndex:indexPath.row];
        }else{
            cell.isPricing = NO;
            [cell showBottonLineWithCellHeight:150];

            PPCDataShowModel *model = [PPCDataShowModel convertToMappedObject:self.selectedDic];
            [cell configureCell:model withIndex:indexPath.row];
        }
        return cell;
    }else{
        RTListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[RTListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
        }
        if ((indexPath.row == 0 || indexPath.row == 3)) {
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.row == 4){
            [cell showTopLine];
            [cell showBottonLineWithCellHeight:45];
            cell.textLabel.text = @"待推广房源";
            cell.textLabel.textColor = [UIColor brokerBlackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }else if (indexPath.row == 5){
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
            lab.backgroundColor = [UIColor clearColor];
            lab.textAlignment = NSTextAlignmentRight;
            lab.textColor = [UIColor brokerLightGrayColor];
            lab.text = @"以上均为今日数据";
            lab.font = [UIFont ajkH5Font];
            [cell.contentView addSubview:lab];
        }
        
        return cell;
    }
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.navigationController.view.frame.origin.x > 0) {
        return;
    }
    
    if (indexPath.row == 1) {

        if (self.pricingDic && self.pricingDic[@"planId"]) {
            PPCPriceingListViewController *pricingListVC = [[PPCPriceingListViewController alloc] init];
            pricingListVC.isHaozu = self.isHaozu;
            pricingListVC.planId = self.pricingDic[@"planId"];
            [self.navigationController pushViewController:pricingListVC animated:YES];
        }else{
            return;
        }
    }else if (indexPath.row == 2){
        if (self.selectedDic[@"data"] && self.selectedDic[@"data"][@"planId"]) {
            PPCSelectedListViewController *selectedListVC = [[PPCSelectedListViewController alloc] init];
            selectedListVC.isHaozu = self.isHaozu;
            selectedListVC.planId = self.selectedDic[@"data"][@"planId"];
            [self.navigationController pushViewController:selectedListVC animated:YES];
        }else{
            return;
        }
    } else if (indexPath.row == 4) {
        if (self.isHaozu) {
            HZWaitingForPromotedViewController *hzToBePromoted = [[HZWaitingForPromotedViewController alloc] init];
            hzToBePromoted.planId = self.pricingDic[@"planId"];
            [self.navigationController pushViewController:hzToBePromoted animated:YES];
        } else {
            ESFWaitingForPromotedViewController *esfToBePromoted = [[ESFWaitingForPromotedViewController alloc] init];
            esfToBePromoted.planId = self.pricingDic[@"planId"];
            [self.navigationController pushViewController:esfToBePromoted animated:YES];
        }
    }
}

- (void)doRequest{
    if (![self isNetworkOkayWithNoInfo]) {
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        
        self.pricingDic = nil;
        self.selectedDic = nil;
        [self.tableList reloadData];
        
        return;
    }
    
    self.isLoading = YES;
    NSMutableDictionary *params = nil;
    NSString *method = @"batch/";
    if (self.isHaozu) {
        NSMutableDictionary *requeseParams1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId",[LoginManager getCity_id],@"cityId", nil];
        
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @"GET",@"method",
                              @"zufang/fix/summary/",@"relative_url",
                              requeseParams1,@"query_params",nil];
        
        NSMutableDictionary *requeseParams2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId",[LoginManager getCity_id],@"cityId", nil];

        NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"GET",@"method",
                                     @"zufang/choice/summary/",@"relative_url",
                                     requeseParams2,@"query_params",nil];
        
        NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     dic1, @"fix",
                                     dic2, @"choice", nil];
        
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  dics, @"requests", nil];
    }else{
        NSMutableDictionary *requeseParams1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId",[LoginManager getCity_id],@"cityId", nil];
        
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"GET",@"method",
                                     @"anjuke/fix/summary/",@"relative_url",
                                     requeseParams1,@"query_params",nil];
        
        NSMutableDictionary *requeseParams2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId",[LoginManager getCity_id],@"cityId", nil];
        
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"GET",@"method",
                                     @"anjuke/choice/summary/",@"relative_url",
                                     requeseParams2,@"query_params",nil];
        
        NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     dic1, @"fix",
                                     dic2, @"choice", nil];
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];

        
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  jsonString, @"requests", nil];
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
        
        [self.pricingDic removeAllObjects];
        [self.selectedDic removeAllObjects];
        [self.tableList reloadData];
        
        return ;
    }
    
    [self donePullDown];
    
    NSDictionary *bodyDic1 = [[response content][@"data"][@"responses"][@"fix"][@"body"] JSONValue];
    NSDictionary *bodyDic2 = [[response content][@"data"][@"responses"][@"choice"][@"body"] JSONValue];
    
    if (bodyDic1[@"status"] && [bodyDic1[@"status"] isEqualToString:@"ok"]) {
        self.pricingDic = [bodyDic1 objectForKey:@"data"];
    }else{
        self.pricingDic = nil;
    }
    
    if (bodyDic2[@"status"] && [bodyDic2[@"status"] isEqualToString:@"ok"]) {
        self.selectedDic = [bodyDic2 objectForKey:@"data"];
    }else{
        self.selectedDic = nil;
    }
    
    if (!self.pricingDic && !self.selectedDic) {
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];

        [self.tableList reloadData];
    }else{
        if ([[self.pricingDic objectForKey:@"totalProps"] intValue] == 0 && [[self.selectedDic objectForKey:@"totalProps"] intValue] == 0) {
            [self.tableList setTableStatus:STATUSFORNODATAFORNOHOUSE];
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
            tapGes.delegate                = self;
            tapGes.numberOfTouchesRequired = 1;
            tapGes.numberOfTapsRequired    = 1;
            [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
            
            self.pricingDic = nil;
            self.selectedDic = nil;
            
            [self.tableList reloadData];
        }else{
            [self.tableList setTableStatus:STATUSFOROK];
            NSIndexPath *path1 = [NSIndexPath indexPathForItem:1 inSection:0];
            NSIndexPath *path2 = [NSIndexPath indexPathForItem:2 inSection:0];
            
            [self.tableList reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path1, nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableList reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path2, nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
- (void)tapGus:(UITapGestureRecognizer *)gesture{
    [self autoPullDown];
}
#pragma mark -- rightButton
- (void)rightButtonAction:(id)sender{
    CommunityListViewController *controller = [[CommunityListViewController alloc] init];
    controller.backType = RTSelectorBackTypeNone;
    controller.isFirstShow = YES;
    controller.isHaouzu = self.isHaozu;
    RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
