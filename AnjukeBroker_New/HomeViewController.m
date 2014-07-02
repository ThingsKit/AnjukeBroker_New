//
//  AJK_HomeViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "HomeViewController.h"
#import "AnjukeEditPropertyViewController.h"
#import "SystemMessageViewController.h"
#import "Util_UI.h"
#import "BrokerLineView.h"
#import "WebImageView.h"
#import "LoginManager.h"
#import "AppManager.h"
#import "AXPhotoManager.h"
#import "RTGestureBackNavigationController.h"

#import "PublishBuildingViewController.h"
#import "CommunityListViewController.h"
#import "FindHomeViewController.h"
#import "BrokerAccountController.h"
#import "BrokerTwoDimensionalCodeViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#import "AXChatMessageCenter.h"
#import "AppDelegate.h"
#import "BrokerWebViewController.h"
#import "LocationManager.h"
#import "RTNetworkResponse.h"
#import "AXIMGDownloader.h"
#import "IMGDowloaderManager.h"
#import "CheckoutCommunityViewController.h"

#import "SaleBidDetailController.h"
#import "SaleFixedDetailController.h"
#import "SaleNoPlanGroupController.h"
#import "SelectionToolView.h"
#import "RentNoPlanController.h"
#import "RentBidDetailController.h"
#import "RentFixedDetailController.h"
#import "SegmentView.h"

#import "RushPropertyViewController.h"
#import "FindCustomerViewController.h"
#import "FindHomeViewController.h"
#import "CheckoutCommunityViewController.h"
#import "WXDataShowViewController.h"
#import "AnjukeHomeViewController.h"
#import "HaozuHomeViewController.h"

#import "PPCDataShowViewController.h"

#import "PricePromotionPropertySingleViewController.h"

#define HOME_cellHeight 70
#define Max_Account_Lb_Width 80

#define HEADER_VIEW1_Height 250
#define HEADER_VIEW2_Height 125
#define HEADER_VIEW_WHOLE_HEIGHT HEADER_VIEW1_Height+HEADER_VIEW2_Height

@interface HomeViewController ()
@property (nonatomic, strong) NSMutableArray *taskArray;

@property (nonatomic, strong) WebImageView *photoImg;
@property (nonatomic, strong) AXIMGDownloader *imgDownloader;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableDictionary *ppcDataDic;
@property BOOL isAJK;
@property (nonatomic, strong) NSString *isSeedPid;
@property (nonatomic, strong) NSMutableArray *myArray;

@property (nonatomic, strong) UILabel *tapName;
@property (nonatomic, strong) UILabel *tapValue;
@property (nonatomic, strong) UILabel *costName;
@property (nonatomic, strong) UILabel *costValue;

@property BOOL configChecked;
@property (nonatomic, copy) NSString *loadingURL;
@property (nonatomic, strong) UIButton *topAlertButton;
@property (nonatomic, strong) SelectionToolView *selectionView;
@property (nonatomic, strong) UIControl *shadeControl;
@property (nonatomic, strong) NSMutableDictionary *hzDataDic;
@property (nonatomic, strong) NSMutableDictionary *ajkDataDic;
@property (nonatomic, strong) SegmentView *segment;
@property (nonatomic, strong) HomeHeaderView *headerView;
@property BOOL isCurrentHZ;


@end

@implementation HomeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isCurrentHZ = NO;
        // Custom initialization
    }
    return self;
}

- (AXIMGDownloader *)imgDownloader {
    if (_imgDownloader == nil) {
        _imgDownloader = [[AXIMGDownloader alloc] init];
    }
    return _imgDownloader;
}


- (HomeHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 140)];
        _headerView.btnClickDelegate = self;
    }
    return _headerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BrokerLogger sharedInstance] logWithActionCode:HOME_ONVIEW page:HOME note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];

    [self initView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRequestInfoAndPPC) name:@"LOGINSUCCESSNOTIFICATION" object:nil];
}

- (void)initModel {
    self.isAJK = YES;
    self.taskArray = [NSMutableArray arrayWithObjects:@"定价房源", @"竞价房源", @"待推广房源", nil];
    self.hzDataDic = [NSMutableDictionary dictionary];
    self.ajkDataDic = [NSMutableDictionary dictionary];
    
    self.dataDic = [NSMutableDictionary dictionary];
    self.ppcDataDic = [NSMutableDictionary dictionary];
    self.myArray = [NSMutableArray array];
}

- (void)initView {
    [self setTitleViewWithString:@"首页"];
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_BETWEEN_NAV_TAB style:UITableViewStylePlain];
    self.myTable = tv;
    tv.backgroundColor = [UIColor brokerBgPageColor];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.showsHorizontalScrollIndicator = NO;
    tv.showsVerticalScrollIndicator = NO;
    tv.tableHeaderView = self.headerView;
    [self.view addSubview:tv];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self doRequest];
    if (!self.configChecked) {
        [self requestForConfigure];
    }
    
    [self requestPropertyCount]; //请求可抢房源数
    [self requestCustomerCount]; //请求可抢用户数
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark 请求可抢房源数 以及 可抢客户数
- (void)requestPropertyCount{
    NSString* method = @"commission/count/";
    NSDictionary* params = @{@"brokerId":[LoginManager getUserID], @"token":[LoginManager getToken]};
//    NSDictionary* params = @{@"brokerId":@"234", @"token":[LoginManager getToken]};
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onPropertyCountFinished:)];
}

- (void)requestCustomerCount{
    NSString* method = @"customer/usercount/";
    NSDictionary* params = @{@"broker_id":[LoginManager getUserID], @"token":[LoginManager getToken]};
//    NSDictionary* params = @{@"broker_id":@"234", @"token":[LoginManager getToken]};
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onCustomerCountFinished:)];
}

#pragma mark -
#pragma mark 请求回调方法

- (void)onPropertyCountFinished:(RTNetworkResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    RTNetworkResponseStatus status = response.status;
    

    if (status == RTNetworkResponseStatusSuccess) { //请求数据成功
        NSDictionary* content = response.content;
        
        if ([@"ok" isEqualToString:[content objectForKey:@"status"]]) {
            NSString* count = [[content objectForKey:@"data"] objectForKey:@"count"];
            self.propertyCount = [count integerValue];
            //cell设置badge
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            HomeCell* cell = (HomeCell*)[self.myTable cellForRowAtIndexPath:indexPath];
            if (self.propertyCount == 0) {
                [cell showDot:NO dotNum:[count integerValue] offsetX:85];
            }else{
                [cell showDot:YES dotNum:[count integerValue] offsetX:85];
            }
            
            if ((self.propertyCount + self.customerCount) == 0) {
                self.navigationController.tabBarItem.badgeValue = nil;
            }else{
                self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.propertyCount + self.customerCount];
            }
            
        }else{
            
        }
        
    }else{
        
    }
}


- (void)onCustomerCountFinished:(RTNetworkResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    RTNetworkResponseStatus status = response.status;
    

    if (status == RTNetworkResponseStatusSuccess) { //请求数据成功
        NSDictionary* content = response.content;
        
        if ([@"ok" isEqualToString:[content objectForKey:@"status"]]) {
            NSString* count = [[content objectForKey:@"data"] objectForKey:@"count"];
            self.customerCount = [count integerValue];
            //cell设置badge
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            HomeCell* cell = (HomeCell*)[self.myTable cellForRowAtIndexPath:indexPath];
            if (self.customerCount == 0) {
                [cell showDot:NO dotNum:[count integerValue] offsetX:85];
            }else{
                [cell showDot:YES dotNum:[count integerValue] offsetX:85];
            }
            
            if ((self.propertyCount + self.customerCount) == 0) {
                self.navigationController.tabBarItem.badgeValue = nil;
            }else{
                self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.propertyCount + self.customerCount];
            }
            
        }else{
            
        }
        
    }else{
        
    }
}


#pragma mark - Request Method
- (void)doRequest {
    [self doRequestInfoAndPPC];
}

- (void)doRequestInfoAndPPC {
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    
    self.isLoading = YES;
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",[LoginManager getCity_id], @"cityId", @"1", @"chatFlag", nil];
    method = @"broker/getinfoandppc/";
    
    
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}

- (void)onRequestFinished:(RTNetworkResponse *)response {
    DLog(@"。。。response [%@]", [response content]);
    [self hideLoadWithAnimated:YES];

    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        DLog(@"errorMsg--->>%@",errorMsg);
        
        self.isLoading = NO;
        
        return;
    }
    
    self.dataDic = [[[response content] objectForKey:@"data"] objectForKey:@"brokerBaseInfo"];
    self.ppcDataDic = [[[response content] objectForKey:@"data"] objectForKey:@"brokerPPCInfo"];
    
    if ([LoginManager getChatID].length <=0 || [LoginManager getChatID] == nil) {
        //保存聊天id和聊天token
        NSString *chatID = [[[response content] objectForKey:@"data"] objectForKey:@"chatId"];
        
        NSString *tokenChat = [[[response content] objectForKey:@"data"] objectForKey:@"tokenChat"];
        NSString *phone = [self.dataDic objectForKey:@"phone"];
        NSString *realName = [self.dataDic objectForKey:@"brokerName"]; //真实姓名保存
        NSString *twoCodeIcon = [[[response content] objectForKey:@"data"] objectForKey:@"twoCodeIcon"];
        
        //保存
        [[NSUserDefaults standardUserDefaults] setValue:chatID forKey:@"chatID"];
        [[NSUserDefaults standardUserDefaults] setValue:tokenChat forKey:@"tokenChat"];
        [[NSUserDefaults standardUserDefaults] setValue:phone forKey:@"phone"]; //联系电话
        [[NSUserDefaults standardUserDefaults] setValue:realName forKey:@"realName"]; //真实姓名
        [[NSUserDefaults standardUserDefaults] setValue:twoCodeIcon forKey:@"twoCodeIcon"]; //二维码
        
        
    }
    if ([[LoginManager getChatID] isEqualToString:@""] || ![LoginManager getChatID]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"chatID为空，请求有误，请重新登录" delegate:self cancelButtonTitle:@"退出重新登录" otherButtonTitles:nil, nil];
        [alert show];
    }

    //保存头像
    AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[LoginManager getChatID]];
    self.img = [[IMGDowloaderManager alloc] init];
    if (person.iconPath.length < 2) {
        if ([LoginManager getUse_photo_url] && ![[LoginManager getUse_photo_url] isEqualToString:@""]) {
            //            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[LoginManager getUse_photo_url]]];
            if (self.photoImg) {
                [self.imgDownloader dowloadIMGWithURL:[NSURL URLWithString:[LoginManager getUse_photo_url]] resultBlock:^(RTNetworkResponse *response) {
                    if (response.status == 2) {
                        if (response.content && [response.content objectForKey:@"imagePath"]) {
                            UIImage *image = [UIImage imageWithContentsOfFile:[response.content objectForKey:@"imagePath"]];
                            NSArray*libsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                            NSString*libPath = [libsPath objectAtIndex:0];
                            NSString *userFolder = [libPath stringByAppendingPathComponent:[LoginManager getChatID]];
                            if ([UIImageJPEGRepresentation(image, 0.96) writeToFile:userFolder atomically:YES]) {
                            }else{
                            }
                            AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[LoginManager getChatID]];
                            person.iconUrl = [LoginManager getUse_photo_url];
                            person.iconPath = [LoginManager getChatID];
                            person.isIconDownloaded = YES;
                            [[AXChatMessageCenter defaultMessageCenter] updatePerson:person];
                        }
                    }
                }];
            }
        }
    }
    
    
    if (!self.hasLongLinked) {
        if (![LoginManager getChatID] || [[LoginManager getChatID] isEqualToString:@""] || [LoginManager getChatID] == nil) {
            
        }
        else {
            //            [self setTitleViewWithString:[LoginManager getRealName]];
            //            [self setTitleViewWithString:@"房源"];
            //******兼容安居客team得到userInfoDic并设置NSUserDefaults，以帮助底层通过对应路径获取相应数据******
            NSDictionary *dic = [LoginManager getFuckingChatUserDicJustForAnjukeTeamWithPhone:[LoginManager getPhone] uid:[LoginManager getChatID] token:[LoginManager getChatToken]];
            [[NSUserDefaults standardUserDefaults] setValue:dic forKey:USER_DEFAULT_KEY_AXCHATMC_USE];
            [AXChatMessageCenter defaultMessageCenter];
            
            [[AppDelegate sharedAppDelegate] connectLongLinkForChat];
            
        }
        self.hasLongLinked = YES;
    }
    
    self.isLoading = NO;
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[AppDelegate sharedAppDelegate] doLogOut];
}

- (void)requestForConfigure {
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    method = @"globalconf/";
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestConfigureFinished:)];
}

- (void)onRequestConfigureFinished:(RTNetworkResponse *)response {
    DLog(@"。。。configure response [%@]", [response content]);
    [self hideLoadWithAnimated:YES];

    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        DLog(@"errorMsg--->>%@",errorMsg);
        
        return;
    }
    
    self.configChecked = YES;
    
    NSDictionary *resultFromAPI = [[response content] objectForKey:@"data"];
    NSLog(@"resultFromAPI-->>%@",resultFromAPI);
    NSArray *frendOverNumArr = [resultFromAPI objectForKey:@"frendOverNum"]; //好友上限用
    [[NSUserDefaults standardUserDefaults] setValue:frendOverNumArr forKey:@"frendOverNumArr"];
    
    NSArray *checkTimeArr = [[resultFromAPI objectForKey:@"sign"] objectForKey:@"signTime"]; //签到时间段
    [[NSUserDefaults standardUserDefaults] setValue:checkTimeArr forKey:@"checkTimeArr"];
    
    NSString *signMile = [NSString stringWithFormat:@"%@",[[resultFromAPI objectForKey:@"sign"] objectForKey:@"signMile"]];//签到区域
    [[NSUserDefaults standardUserDefaults] setValue:signMile forKey:@"signMile"];
    
    NSDictionary *tipsDic = [resultFromAPI objectForKey:@"tips"]; //是否显示状态条并跳转webView
    if ([[tipsDic objectForKey:@"openFlag"] isEqualToString:@"1"]) {//开启弹窗和跳转 test
        //        [self showWebViewJumpWithDic:tipsDic];
    }
    else {
        //        [self hideWebViewJumpBtn];
    }
}


- (void)uploadAJKTableData {
    self.isCurrentHZ = NO;
    [self.taskArray removeAllObjects];
    for (NSDictionary *tempDic in [self.ajkDataDic objectForKey:@"ajkFixHouse"]) {
        NSString *fixedStr = [NSString stringWithFormat:@"%@(%@)", @"定价房源", [tempDic objectForKey:@"fixNum"]];
        [self.taskArray addObject:fixedStr];
    }
    if ([self.taskArray count] == 1) {
        self.isSeedPid = [[[self.ajkDataDic objectForKey:@"ajkFixHouse"] objectAtIndex:0] objectForKey:@"fixId"];
    }
    NSString *bidStr = [NSString stringWithFormat:@"竞价房源(%@)", [self.ajkDataDic objectForKey:@"ajkBidHouseNum"]];
    NSString *noplanStr = [NSString stringWithFormat:@"待推广房源(%@)", [self.ajkDataDic objectForKey:@"ajkNotFixHouseNum"]];
    [self.taskArray addObject:bidStr];
    [self.taskArray addObject:noplanStr];
    self.tapValue.text = [self.ajkDataDic objectForKey:@"ajkClick"];
    self.costValue.text = [self.ajkDataDic objectForKey:@"ajkConsume"];
    [self.myTable reloadData];
}

- (void)uploadHZTableData {
    self.isCurrentHZ = YES;
    [self.taskArray removeAllObjects];
    for (NSDictionary *tempDic in [self.hzDataDic objectForKey:@"hzFixHouse"]) {
        NSString *fixedStr = [NSString stringWithFormat:@"%@(%@)", @"定价房源", [tempDic objectForKey:@"fixNum"]];
        [self.taskArray addObject:fixedStr];
    }
    if ([self.taskArray count] == 1) {
        self.isSeedPid = [[[self.hzDataDic objectForKey:@"hzFixHouse"] objectAtIndex:0] objectForKey:@"fixId"];
    }
    NSString *bidStr = [NSString stringWithFormat:@"竞价房源(%@)", [self.hzDataDic objectForKey:@"hzBidHouseNum"]];
    NSString *noplanStr = [NSString stringWithFormat:@"待推广房源(%@)", [self.hzDataDic objectForKey:@"hzNotFixHouseNum"]];
    [self.taskArray addObject:bidStr];
    [self.taskArray addObject:noplanStr];
    self.tapValue.text = [self.hzDataDic objectForKey:@"hzClick"];
    self.costValue.text = [self.hzDataDic objectForKey:@"hzConsume"];
    [self.myTable reloadData];
}

#pragma mark - tableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HOME_cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = @[@"抢房源=房东房源，一网打尽",@"抢客户=推荐房源，招揽客户",@"小区签到=刷存在感，让客户找到你",@"微聊数据=数据是成功的秘诀"];
    
    static NSString *cellIdentify = @"cell";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    
    if (cell == nil) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    [cell configWithModel:arr indexPath:indexPath];
    if (indexPath.row == 0) {
        [cell showTopLine];
        [cell showBottonLineWithCellHeight:HOME_cellHeight andOffsetX:32];
    }else if (indexPath.row < 3){
        [cell showBottonLineWithCellHeight:HOME_cellHeight andOffsetX:32];
    }else{
        [cell showBottonLineWithCellHeight:HOME_cellHeight];
    }
    
    if (indexPath.row == 1) {
        [cell showDot:NO dotNum:0 offsetX:85];
    }

    return cell;
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        //########################################################
        //测试房源单页
        PricePromotionPropertySingleViewController* viewController = [[PricePromotionPropertySingleViewController alloc] init];
        [viewController setHidesBottomBarWhenPushed:YES];
        viewController.backType = RTSelectorBackTypePopBack;
        [self.navigationController pushViewController:viewController animated:YES];
        //#########################################################
        
//        [[BrokerLogger sharedInstance] logWithActionCode:HOME_COMMISSION page:HOME note:nil]; //点击抢房源
//        RushPropertyViewController *rushPropertyVC = [[RushPropertyViewController alloc] init];
//        [rushPropertyVC setHidesBottomBarWhenPushed:YES];
//        rushPropertyVC.backType = RTSelectorBackTypePopBack;
//        [self.navigationController pushViewController:rushPropertyVC animated:YES];
    }else if (indexPath.row == 1){
        [[BrokerLogger sharedInstance] logWithActionCode:HOME_POTENTIAL_CLIENT page:HOME note:nil]; //点击抢客户

        FindCustomerViewController *findCustomerVC = [[FindCustomerViewController alloc] init];
        [findCustomerVC setHidesBottomBarWhenPushed:YES];
        findCustomerVC.backType = RTSelectorBackTypePopBack;
        [self.navigationController pushViewController:findCustomerVC animated:YES];
    }else if (indexPath.row == 2){
        [[BrokerLogger sharedInstance] logWithActionCode:HOME_SIGNIN page:HOME note:nil]; //点击小区签到

        CheckoutCommunityViewController *checkoutCommunityVC = [[CheckoutCommunityViewController alloc] init];
        [checkoutCommunityVC setHidesBottomBarWhenPushed:YES];
        checkoutCommunityVC.backType = RTSelectorBackTypePopBack;
        [self.navigationController pushViewController:checkoutCommunityVC animated:YES];
    }else if (indexPath.row == 3){
        [[BrokerLogger sharedInstance] logWithActionCode:HOME_DATA page:HOME note:nil];

        WXDataShowViewController *wxDataVC = [[WXDataShowViewController alloc] init];
        [wxDataVC setHidesBottomBarWhenPushed:YES];
        wxDataVC.backType = RTSelectorBackTypePopBack;
        [self.navigationController pushViewController:wxDataVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- headerBtnClickDelegate
- (void)btnClickWithTag:(NSInteger)index{
    if (index == 0) {
//        [[BrokerLogger sharedInstance] logWithActionCode:HOME_ESF page:HOME note:nil]; //点击二手房管理
//        
//        AnjukeHomeViewController *ajkHomeVC = [[AnjukeHomeViewController alloc] init];
//        ajkHomeVC.backType = RTSelectorBackTypePopBack;
//        [ajkHomeVC setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:ajkHomeVC animated:YES];
        
        PPCDataShowViewController *ppcDataShowVC = [[PPCDataShowViewController alloc] init];
        ppcDataShowVC.isHaozu = NO;
        ppcDataShowVC.backType = RTSelectorBackTypePopBack;
        [ppcDataShowVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:ppcDataShowVC animated:YES];
    }else if (index == 1){
//        [[BrokerLogger sharedInstance] logWithActionCode:HOME_ZF page:HOME note:nil]; //点击租房管理
//        
//        HaozuHomeViewController *HaozuHomeVC = [[HaozuHomeViewController alloc] init];
//        HaozuHomeVC.backType = RTSelectorBackTypePopBack;
//        [HaozuHomeVC setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:HaozuHomeVC animated:YES];

        PPCDataShowViewController *ppcDataShowVC = [[PPCDataShowViewController alloc] init];
        ppcDataShowVC.isHaozu = YES;
        ppcDataShowVC.backType = RTSelectorBackTypePopBack;
        [ppcDataShowVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:ppcDataShowVC animated:YES];
    }else if (index == 2){
        [[BrokerLogger sharedInstance] logWithActionCode:HOME_MARKET page:HOME note:nil]; //点击市场分析
        
        FindHomeViewController *findHome = [[FindHomeViewController alloc] init];
        findHome.backType = RTSelectorBackTypePopBack;
        [findHome setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:findHome animated:YES];
    }
}
@end
