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
#import "WaitingForPromotedViewController.h"
#import "PPCDataShowModel.h"
#import "CommunityListViewController.h"
#import "RTGestureBackNavigationController.h"
#import "SaleBidDetailController.h"
#import "SaleFixedDetailController.h"
#import "SaleNoPlanGroupController.h"
#import "RentBidDetailController.h"
#import "RentFixedDetailController.h"
#import "RentNoPlanController.h"

@interface PPCDataShowViewController ()
@property(nonatomic, strong) NSMutableDictionary *pricingDic;
@property(nonatomic, strong) NSMutableDictionary *secondCellDic;
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
        self.secondCellDic = [[NSMutableDictionary alloc] init];
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

    UIBarButtonItem *rightItem = [UIBarButtonItem getBarButtonItemWithImage:[UIImage imageNamed:@"anjuke_icon_add_.png"] highLihtedImg:[UIImage imageNamed:@"anjuke_icon_add_press"] taget:self action:@selector(rightButtonAction:)];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {//fix ios7以下 10像素偏离
        UIBarButtonItem *spacer = [UIBarButtonItem getBarSpace:10.0];
        [self.navigationItem setRightBarButtonItems:@[spacer, rightItem]];
    }else{
        self.navigationItem.rightBarButtonItem = rightItem;
    }

    
    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableList];

    [self autoPullDown];
}


#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.pricingDic && !self.secondCellDic) {
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
            cell.cellType = CELLTYPEFORPRICING;
//            cell.isPricing = YES;
            [cell showBottonLineWithCellHeight:150 andOffsetX:15];
            
            PPCDataShowModel *model = [PPCDataShowModel convertToMappedObject:self.pricingDic];
            [cell configureCell:model withIndex:indexPath.row];
        }else{
//            cell.isPricing = NO;
            if ([[LoginManager getBusinessType] isEqualToString:@"1"]) {
                cell.cellType = CELLTYPEFORBIT;
            }else{
                cell.cellType = CELLTYPEFORSELECTING;
            }
            [cell showBottonLineWithCellHeight:150];

            PPCDataShowModel *model = [PPCDataShowModel convertToMappedObject:self.secondCellDic];
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
    
    if (self.isLoading) {
        return;
    }
    
    if (indexPath.row == 1) {
        if (self.pricingDic && self.pricingDic[@"planId"]) {
            if ([[LoginManager getBusinessType] isEqualToString:@"1"]){
                if (self.isHaozu) {
                    [[BrokerLogger sharedInstance] logWithActionCode:ZF_MANAGE_FIXLIST page:ZF_MANAGE note:nil];
                    
                    RentFixedDetailController *controller = [[RentFixedDetailController alloc] init];
                    controller.tempDic = self.pricingDic;
                    [controller setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:controller animated:YES];
                }else{
                    [[BrokerLogger sharedInstance] logWithActionCode:ESF_MANAGE_DRAFTLIST page:ESF_MANAGE note:nil];
                    
                    SaleFixedDetailController *controller = [[SaleFixedDetailController alloc] init];
                    controller.tempDic = self.pricingDic;
                    [controller setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }else{
                PPCPriceingListViewController *pricingListVC = [[PPCPriceingListViewController alloc] init];
                pricingListVC.isHaozu = self.isHaozu;
                pricingListVC.planId = self.pricingDic[@"planId"];
                [self.navigationController pushViewController:pricingListVC animated:YES];
            }
        }else{
            return;
        }
    }else if (indexPath.row == 2){
        if ([[LoginManager getBusinessType] isEqualToString:@"1"]) {
            if (self.isHaozu) {
                [[BrokerLogger sharedInstance] logWithActionCode:ZF_MANAGE_BIDLIST page:ZF_MANAGE note:nil];
                
                RentBidDetailController *controller = [[RentBidDetailController alloc] init];
                [controller setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [[BrokerLogger sharedInstance] logWithActionCode:ESF_MANAGE_FIXLIST page:ESF_MANAGE note:nil];
                
                SaleBidDetailController *controller = [[SaleBidDetailController alloc] init];
                [controller setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else{
            PPCSelectedListViewController *selectedListVC = [[PPCSelectedListViewController alloc] init];
            selectedListVC.isHaozu = self.isHaozu;
            [self.navigationController pushViewController:selectedListVC animated:YES];
        }
        
    } else if (indexPath.row == 4) {
        if (self.pricingDic && self.pricingDic[@"planId"]) {
            if (self.isHaozu) {
                if ([[LoginManager getBusinessType] isEqualToString:@"1"]) {
                    [[BrokerLogger sharedInstance] logWithActionCode:ESF_MANAGE_BIDLIST page:ESF_MANAGE note:nil];
                    
                    SaleNoPlanGroupController *controller = [[SaleNoPlanGroupController alloc] init];
                    controller.isSeedPid = self.pricingDic[@"planId"];
                    [controller setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:controller animated:YES];
                } else {
                    WaitingForPromotedViewController *hzToBePromoted = [[WaitingForPromotedViewController alloc] init];
                    hzToBePromoted.isHaozu = YES;
                    hzToBePromoted.planId = self.pricingDic[@"planId"];
                    [self.navigationController pushViewController:hzToBePromoted animated:YES];
                }
            } else {
                if ([[LoginManager getBusinessType] isEqualToString:@"1"]) {
                    [[BrokerLogger sharedInstance] logWithActionCode:ZF_MANAGE_DRAFTLIST page:ZF_MANAGE note:nil];
                    
                    RentNoPlanController *controller = [[RentNoPlanController alloc] init];
                    controller.isSeedPid = self.pricingDic[@"planId"];
                    [controller setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:controller animated:YES];

                } else {
                    WaitingForPromotedViewController *esfToBePromoted = [[WaitingForPromotedViewController alloc] init];
                    esfToBePromoted.planId = self.pricingDic[@"planId"];
                    esfToBePromoted.isHaozu = NO;
                    [self.navigationController pushViewController:esfToBePromoted animated:YES];
                }
            }
        }
    }
}

- (void)doRequest{
    if (![self isNetworkOkayWithNoInfo]) {
        
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        self.isLoading = NO;

        self.pricingDic = nil;
        self.secondCellDic = nil;
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
        
        if ([[LoginManager getBusinessType] isEqualToString:@"1"]){
            NSMutableDictionary *requeseParams2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId",[LoginManager getCity_id],@"cityId",  nil];
            
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         @"GET",@"method",
                                         @"zufang/bid/summary/",@"relative_url",
                                         requeseParams2,@"query_params",nil];
            
            NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         dic1, @"fix",
                                         dic2, @"secondApi", nil];
            
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      dics, @"requests", nil];
        }else{
            NSMutableDictionary *requeseParams2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId",[LoginManager getCity_id],@"cityId", nil];
            
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         @"GET",@"method",
                                         @"zufang/choice/summary/",@"relative_url",
                                         requeseParams2,@"query_params",nil];
            
            NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         dic1, @"fix",
                                         dic2, @"secondApi", nil];
            
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      dics, @"requests", nil];
        }
    }else{
        NSMutableDictionary *requeseParams1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId",[LoginManager getCity_id],@"cityId", nil];
        
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"GET",@"method",
                                     @"anjuke/fix/summary/",@"relative_url",
                                     requeseParams1,@"query_params",nil];
        
        
        if ([[LoginManager getBusinessType] isEqualToString:@"1"]) {
            NSMutableDictionary *requeseParams2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId", nil];
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         @"GET",@"method",
                                         @"anjuke/bid/summary/",@"relative_url",
                                         requeseParams2,@"query_params",nil];
            
            NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         dic1, @"fix",
                                         dic2, @"secondApi", nil];
            
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
            
            
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      jsonString, @"requests", nil];
        }else{
            NSMutableDictionary *requeseParams2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId",[LoginManager getCity_id],@"cityId", nil];

            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         @"GET",@"method",
                                         @"anjuke/choice/summary/",@"relative_url",
                                         requeseParams2,@"query_params",nil];
            
            NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         dic1, @"fix",
                                         dic2, @"secondApi", nil];
            
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
            
            
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      jsonString, @"requests", nil];
        }
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
        
        self.pricingDic = nil;
        self.secondCellDic = nil;
        [self.tableList reloadData];
        
        return ;
    }
    
    [self donePullDown];
    
    NSDictionary *bodyDic1 = [[response content][@"data"][@"responses"][@"fix"][@"body"] JSONValue];
    NSDictionary *bodyDic2 = [[response content][@"data"][@"responses"][@"secondApi"][@"body"] JSONValue];
    
    if (bodyDic1[@"status"] && [bodyDic1[@"status"] isEqualToString:@"ok"]) {
        self.pricingDic = [bodyDic1 objectForKey:@"data"];
    }else{
        self.pricingDic = nil;

        if (!bodyDic1[@"status"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"定价计划请求失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新请求", nil];
            [alert show];
            
            return;
        }
    }
    
    if (bodyDic2[@"status"] && [bodyDic2[@"status"] isEqualToString:@"ok"]) {
        self.secondCellDic = [bodyDic2 objectForKey:@"data"];
    }else{
        self.secondCellDic = nil;

        if (!bodyDic2[@"status"]) {
            if ([[LoginManager getBusinessType] isEqualToString:@"1"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"竞价计划请求失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新请求", nil];
                [alert show];
                
                return;
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"精选计划请求失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新请求", nil];
                [alert show];
                
                return;
            }
        }
    }
    
    if (!self.pricingDic && !self.secondCellDic) {
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];

        [self.tableList reloadData];
    }else{
        if ([[self.pricingDic objectForKey:@"totalProps"] intValue] == 0 && [[self.secondCellDic objectForKey:@"totalProps"] intValue] == 0) {
            [self.tableList setTableStatus:STATUSFORNODATAFORNOHOUSE];
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
            tapGes.delegate                = self;
            tapGes.numberOfTouchesRequired = 1;
            tapGes.numberOfTapsRequired    = 1;
            [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
            
            self.pricingDic = nil;
            self.secondCellDic = nil;
            
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

#pragma mark -- UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self autoPullDown];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
