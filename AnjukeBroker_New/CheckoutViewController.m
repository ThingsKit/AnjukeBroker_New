//
//  CheckoutViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CheckoutViewController.h"
#import "BrokerTableStuct.h"
#import "CheckoutCell.h"
#import "CheckoutWebViewController.h"
#import "CheckoutButton.h"
#import "CLLocationManager+RT.h"
#import "CheckInfoWithCommunity.h"
#import "HUDNews.h"
#import "UIFont+RT.h"
#import "UIColor+BrokerRT.h"
#import "UpdateUserLocation.h"

#define HEADERFRAME CGRectMake(0, 0, [self windowWidth], 260)
#define HEADERMAPFRAME CGRectMake(0, 0, [self windowWidth], 180)
#define FRAME_CENTRE_LOC CGRectMake([self windowWidth]/2-10, 180/2-25, 20, 25)
#define CELLHEIGHT_NOFMAL 36
#define CELLHEIGHT_NOCHECK 55
#define CELLHEIGHT_CHECK 105

@interface CheckoutViewController ()<checkoutButtonDelegate>
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UIButton *checkoutBtn;
@property(nonatomic, strong) CheckoutButton *cb;
//user最新2d
@property(nonatomic, assign) CLLocationCoordinate2D nowCoords;
@property(nonatomic, assign) BOOL isLoading;
@property(nonatomic, strong) CheckCommunityModel *checkCommunitmodel;
@property(nonatomic, strong) NSArray *checkTimeArr;//签到时间段
@property(nonatomic, strong) NSString *signMile;
@property(nonatomic, strong) NSMutableArray *checkCellStatusArr;
@property(nonatomic, strong) UILabel *checkoutNumLab;
@property(nonatomic, strong) CheckInfoWithCommunity *checkInfoModel;
@property(nonatomic, strong) MKMapView *map;
@property(nonatomic, assign) BOOL hideCheck;
@end

@implementation CheckoutViewController
@synthesize headerView;
@synthesize checkoutBtn;
@synthesize cb;
@synthesize nowCoords;
@synthesize isLoading;
@synthesize checkCommunitmodel;
@synthesize checkTimeArr;
@synthesize signMile;
@synthesize checkCellStatusArr;
@synthesize checkoutNumLab;
@synthesize checkInfoModel;
@synthesize map;
@synthesize hideCheck;
@synthesize checkStatus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cb = [[CheckoutButton alloc] init];
        cb.checkoutDelegate = self;
        
        [self getCellStatus];

        
//        self.checkCellStatusArr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:CHECKOUTCELLWITHELSE],[NSNumber numberWithInt:CHECKOUTCELLWITHNOCHECK],[NSNumber numberWithInt:CHECKOUTCELLWITHNOCHECK],[NSNumber numberWithInt:CHECKOUTCELLWITHNOCHECK],[NSNumber numberWithInt:CHECKOUTCELLWITHELSE], nil];
//        self.hideCheck = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wakeFromBackGound:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
        [[UpdateUserLocation shareUpdateUserLocation] fetchUserLocationWithComeletionBlock:^(BOOL updateLocationIsOk) {
        }];
    }
    return self;
}
- (void)getCellStatus{
    self.checkTimeArr = [[NSArray alloc] initWithArray:[LoginManager getCheckTimeArr]];
    self.signMile = [NSString stringWithFormat:@"%@",[LoginManager getSignMile]];
    
    //获取签到cell状态
    self.checkCellStatusArr = [[NSMutableArray alloc] init];
    [self.checkCellStatusArr addObject:[NSNumber numberWithInt:CHECKOUTCELLWITHELSE]];
    
    NSArray *timeAreaArr = [[NSArray alloc] initWithArray:[LoginManager getCheckTimeArr]];
    for (int i = 0; i < timeAreaArr.count; i++) {
        [self.checkCellStatusArr addObject:[NSNumber numberWithInt:CHECKOUTCELLWITHNOCHECK]];
    }
    [self.checkCellStatusArr addObject:[NSNumber numberWithInt:CHECKOUTCELLWITHELSE]];

    
    //如果配置文件中，时间段信息无，则隐藏签到活动
    if (timeAreaArr.count == 0) {
        self.hideCheck = YES;
    }
}
- (void)dealloc{
    self.cb.checkoutDelegate = nil;
    self.cb = nil;
}
#pragma mark - log
//- (void)sendAppearLog {
//    [[BrokerLogger sharedInstance] logWithActionCode:CHECK_PAGE_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
//}
- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationWillEnterForegroundNotification];
}
- (void)viewWillAppear:(BOOL)animated{
    [self reloadCheckInfo];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BrokerLogger sharedInstance] logWithActionCode:CHECK_PAGE_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];

    [self addRightButton:@"规则" andPossibleTitle:nil];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)initUI{
    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.backgroundColor = [UIColor brokerBgPageColor];;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableList];
    
    self.headerView = [[UIView alloc] initWithFrame:HEADERFRAME];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 50)];
    footView.backgroundColor = [UIColor clearColor];
    self.tableList.tableFooterView = footView;
    
    self.map = [[MKMapView alloc] initWithFrame:HEADERMAPFRAME];
    self.map.userInteractionEnabled = NO;
    self.map.showsUserLocation = YES;
    self.map.delegate = self;
    [self.headerView addSubview:self.map];

    UIImageView *coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.map.frame.size.height - 7, [self windowWidth], 7)];
    [coverView setImage:[[UIImage imageNamed:@"check_map_cover_shadow"] stretchableImageWithLeftCapWidth:2 topCapHeight:0]];
    coverView.contentMode = UIViewContentModeScaleAspectFill;
    [self.map addSubview:coverView];
    
    UIImageView *certerIcon = [[UIImageView alloc] initWithFrame:FRAME_CENTRE_LOC];
    certerIcon.image = [UIImage imageNamed:@"checkCommunity_icon"];
    [map addSubview:certerIcon];
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(self.checkCommunitmodel.lat,self.checkCommunitmodel.lng);
    float zoomLevel = 0.009;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    region = [map regionThatFits:region];
    [map setRegion:region animated:NO];
    
    //签到按钮
    [self showCheckButton:CHECKBUTTONWITHLOADING timeLeft:0];
    
    self.checkoutNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.checkoutBtn.frame.origin.x+self.checkoutBtn.frame.size.width+10, self.checkoutBtn.frame.origin.y+5, 50, 30)];
    self.checkoutNumLab.lineBreakMode = UILineBreakModeWordWrap;
    self.checkoutNumLab.numberOfLines = 0;
    self.checkoutNumLab.textColor = [UIColor brokerBlackColor];
    self.checkoutNumLab.text = [NSString stringWithFormat:@"-人\n今日已签"];
    self.checkoutNumLab.font = [UIFont ajkH5Font];
    self.checkoutNumLab.textAlignment = NSTextAlignmentCenter;
    self.checkoutNumLab.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:self.checkoutNumLab];
    
    self.tableList.tableHeaderView = self.headerView;
}
#pragma mark - request method
- (void)doRequest{
    [self locationServiceCheck];

    if (!self.nowCoords.latitude) {
        [self donePullDown];
        return;
    }
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];
        self.isLoading = NO;
        return;
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;

//    params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude_specify"] doubleValue]],@"lat",[[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude_specify"] doubleValue],@"lng", nil];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"latitude_specify"]) {
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude_specify"] doubleValue]],@"lat",[NSString stringWithFormat:@"%f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude_specify"] doubleValue]],@"lng",self.checkCommunitmodel.commId,@"commId", nil];
    }else{
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",self.nowCoords.latitude],@"lat",[NSString stringWithFormat:@"%f",self.nowCoords.longitude],@"lng",self.checkCommunitmodel.commId,@"commId", nil];
    }
    
    DLog(@"paramsparam----->>%@",params);
    method = [NSString stringWithFormat:@"broker/commSignDetail/"];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}

- (void)onRequestFinished:(RTNetworkResponse *)response{
    self.isLoading = NO;
    if([[response content] count] == 0){
        [[HUDNews sharedHUDNEWS] createHUD:@"服务器开溜了" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
//        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
//        DLog(@"errorMsg--->>%@",errorMsg);
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];


        return;
    }
    
    NSDictionary *dic = [[response content] objectForKey:@"data"];
    
//    NSArray *timeAreaArr = [[NSArray alloc] initWithArray:[LoginManager getCheckTimeArr]];
//    [[NSUserDefaults standardUserDefaults] setValue:checkTimeArr forKey:@"checkTimeArr"];
    
    NSArray *arr = [NSArray arrayWithArray:[dic objectForKey:@"signList"]];
    NSMutableArray *checkTimesArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; i++) {
        [checkTimesArr addObject:[[arr objectAtIndex:i] objectForKey:@"hour"]];
    }
    [[NSUserDefaults standardUserDefaults] setValue:checkTimesArr forKey:@"checkTimeArr"];
    
    [self getCellStatus];
    
    self.checkInfoModel = [CheckInfoWithCommunity convertToMappedObject:dic];

    if (self.checkInfoModel.signList.count == 0) {
        self.hideCheck = YES;
    }else{
        self.hideCheck = NO;
    }
    
    [self updateUI];
}

- (void)doCheckActionRequest{
    if (!self.nowCoords.latitude) {
        return;
    }
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];
        self.isLoading = NO;
        return;
    }
    if ([self calcDistance] > [self.signMile integerValue]) {
          [[HUDNews sharedHUDNEWS] createHUD:@"您漂移的太远" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];
        self.isLoading = NO;
        return;
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    self.isLoading = YES;

//    params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",self.nowCoords.latitude],@"lat",[NSString stringWithFormat:@"%f",self.nowCoords.longitude],@"lng",self.checkCommunitmodel.commId,@"commId", nil];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"latitude_specify"]) {
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude_specify"]],@"lat",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude_specify"]],@"lng",self.checkCommunitmodel.commId,@"commId", nil];
    }else{
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",self.nowCoords.latitude],@"lat",[NSString stringWithFormat:@"%f",self.nowCoords.longitude],@"lng",self.checkCommunitmodel.commId,@"commId", nil];
    }
//    params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",29.323028],@"lat",[NSString stringWithFormat:@"%f",121.5612314],@"lng",self.checkCommunitmodel.commId,@"commId", nil];
    
    method = [NSString stringWithFormat:@"broker/commSign/"];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onCheckActionRequestFinished:)];
}
- (void)onCheckActionRequestFinished:(RTNetworkResponse *)response{
    if([[response content] count] == 0){
        self.isLoading = NO;

        [[HUDNews sharedHUDNEWS] createHUD:@"服务器开溜了" hudTitleTwo:@"签到失败" addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALOK];
        self.isLoading = NO;
        [self showCheckButton:CHECKBUTTONWITHNORMALSTATUS timeLeft:0];

        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {

        if ([[[response content] objectForKey:@"status"] isEqualToString:@"error"] && [[[response content] objectForKey:@"errcode"] isEqualToString:@"1009"]) {
            [[HUDNews sharedHUDNEWS] createHUD:@"签到失败!" hudTitleTwo:@"你跑得太远了" addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];
        }else{
            [[HUDNews sharedHUDNEWS] createHUD:@"签到失败!" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];
        }
        
        [self showCheckButton:CHECKBUTTONWITHNORMALSTATUS timeLeft:0];

        return;
    }
    
    NSDictionary *dic = [response content];

    if ([dic[@"status"] isEqualToString:@"ok"]) {
        //签到成功后UI处理
        [[HUDNews sharedHUDNEWS] createHUD:@"签到成功" hudTitleTwo:[NSString stringWithFormat:@"本时段第%@位签到者",[[dic objectForKey:@"data"] objectForKey:@"signRank"]] addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHCHECKOK];
        [self showCheckButton:CHECKBUTTONWITHCOUNTDOWN timeLeft:[[[dic objectForKey:@"data"] objectForKey:@"countDown"] intValue]];
        
        [self doRequest];
    }else{
        [[HUDNews sharedHUDNEWS] createHUD:@"签到失败" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALBAD];
        [self showCheckButton:CHECKBUTTONWITHNORMALSTATUS timeLeft:0];
    }
}

#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.hideCheck) {
        return 0;
    }
    return self.checkCellStatusArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch ([[self.checkCellStatusArr objectAtIndex:indexPath.row] intValue]) {
        case CHECKOUTCELLWITHELSE:
            return CELLHEIGHT_NOFMAL;
        case CHECKOUTCELLWITHNOCHECK:
            return CELLHEIGHT_NOCHECK;
        case CHECKOUTCELLWITHCHCK:
            return CELLHEIGHT_CHECK;
            
        default:
            return CELLHEIGHT_NOFMAL;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";    
    CheckoutCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[CheckoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    //创建cell
    [cell configurCell:self.checkInfoModel withIndex:indexPath.row cellType:[[self.checkCellStatusArr objectAtIndex:indexPath.row] intValue]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.navigationController.view.frame.origin.x > 0)
        return;

    if (indexPath.row == self.checkCellStatusArr.count - 1) {
        [self rightButtonAction:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - method
- (void)passCommunityWithModel:(CheckCommunityModel *)model;{
    self.checkCommunitmodel = model;
    
    [self setTitleViewWithString:[NSString stringWithFormat:@"签到-%@",self.checkCommunitmodel.commName]];
}
- (void)rightButtonAction:(id)sender{
    [[BrokerLogger sharedInstance] logWithActionCode:CHECK_PAGE_004 note:nil];
    
    CheckoutWebViewController *webVC = [[CheckoutWebViewController alloc] init];
    webVC.webTitle = @"签到规则";
    webVC.webUrl = @"http://api.anjuke.com/web/nearby/brokersign/rule.html";
    
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)checkoutCommunity:(id)sender{
    [[BrokerLogger sharedInstance] logWithActionCode:CHECK_PAGE_003 note:nil];

    //签到按钮
    [self showCheckButton:CHECKBUTTONWITHCHECKING timeLeft:0];
    
    [self doCheckActionRequest];
}

- (void)showCheckButton:(CHECKBUTTONSTATUS)checkButtonStatus timeLeft:(int)timeLeft{
    if (self.checkoutBtn) {
        [self.checkoutBtn removeFromSuperview];
        self.checkoutBtn = nil;
    }
    //签到中
    if (checkButtonStatus == CHECKBUTTONWITHCHECKING) {
        self.checkoutBtn = [self.cb buttonWithChecking];
    }else if (checkButtonStatus == CHECKBUTTONWITHCOUNTDOWN){
        self.checkoutBtn = [self.cb buttonWithCountdown:timeLeft];
    }else if (checkButtonStatus == CHECKBUTTONWITHLOADING){
        self.checkoutBtn = [self.cb buttonWithLoading];
    }else if (checkButtonStatus == CHECKBUTTONWITHNORMALSTATUS){
        self.checkoutBtn = [self.cb buttonWithNormalStatus];
        [self.checkoutBtn addTarget:self action:@selector(checkoutCommunity:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.checkoutBtn.frame = CGRectMake(15, 180 + 20, 230, 40);
    [self.headerView addSubview:self.checkoutBtn];
}
- (void)updateUI{
    if (self.checkInfoModel.signCount) {
        self.checkoutNumLab.text = [NSString stringWithFormat:@"%d人\n今日已签",[self.checkInfoModel.signCount intValue]];
    }
    
    NSArray *checkInfoArr = [[NSArray alloc] initWithArray:self.checkInfoModel.signList];
    for (int i = 0; i < checkInfoArr.count; i++) {
        NSArray *checkPerson = [[NSArray alloc] initWithArray:[[checkInfoArr objectAtIndex:i] objectForKey:@"brokers"]];
        if (checkPerson.count != 0) {
            [self.checkCellStatusArr replaceObjectAtIndex:i+1 withObject:[NSNumber numberWithInt:CHECKOUTCELLWITHCHCK]];
        }
    }
    
    //未签到或者已经签到但剩余时间为0s,显示可签到按钮
    if ([self.checkInfoModel.signAble intValue] == 1 || ([self.checkInfoModel.countDown intValue] == 0 && [self.checkInfoModel.signAble intValue] == 0) ) {
        [self showCheckButton:CHECKBUTTONWITHNORMALSTATUS timeLeft:0];
    }else{
        [self showCheckButton:CHECKBUTTONWITHCOUNTDOWN timeLeft:[self.checkInfoModel.countDown intValue]];
    }
    
    [self.tableList reloadData];
}
- (void)timeCountZero{
    [self showCheckButton:CHECKBUTTONWITHNORMALSTATUS timeLeft:0];
}
- (void)wakeFromBackGound:(NSNotification *)notification{
    [self reloadCheckInfo];
}

- (void)reloadCheckInfo{
    [self locationServiceCheck];
    
    self.map.showsUserLocation = YES;
    
    [self showCheckButton:CHECKBUTTONWITHLOADING timeLeft:0];
}

- (void)locationServiceCheck{
    if (![CLLocationManager isLocationServiceEnabled]) {
        UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:@"请到“设置->隐私->定位服务”中开启定位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alet show];
    }
}
#pragma mark - MKMapViewDelegate -user location定位变化
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    self.nowCoords = [userLocation coordinate];
    self.map.showsUserLocation = NO;
    [self doRequest];
}
#pragma mark distance计算
- (CLLocationDistance)calcDistance{
    CLLocation *communityLoc = [[CLLocation alloc] initWithLatitude:self.checkCommunitmodel.lat  longitude:self.checkCommunitmodel.lng];
    CLLocation *nowLoc = [[CLLocation alloc] initWithLatitude:self.nowCoords.latitude longitude:self.nowCoords.longitude];
    
    CLLocationDistance kilometers = [communityLoc distanceFromLocation:nowLoc]/1000;
    NSLog(@"距离:--->>%f",kilometers);
    return kilometers;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
