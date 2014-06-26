//
//  CheckoutCommunityViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CheckoutCommunityViewController.h"
#import "CheckoutCommunityCell.h"
#import "BrokerTableStuct.h"
#import "CheckoutViewController.h"
#import "CLLocationManager+RT.h"
#import "HUDNews.h"
#import "UIFont+RT.h"
#import "AppDelegate.h"
#import "UIColor+BrokerRT.h"
#import "CheckoutWebViewController.h"

@interface CheckoutCommunityViewController ()
//@property(nonatomic, strong) CheckCommunityTable *tableList;
@property(nonatomic, strong) NSDictionary *checkoutDic;
//user最新2d
@property(nonatomic, assign) CLLocationCoordinate2D nowCoords;
@property(nonatomic ,strong) NSMutableArray *tablaData;
@property(nonatomic, assign) BOOL isLoading;
@property(nonatomic ,strong) UIButton *refreshBtn;
@property(nonatomic ,strong) MKMapView *map;
@property(nonatomic, assign) double angle;
@property(nonatomic, strong) NSIndexPath *selectCell;
@end

@implementation CheckoutCommunityViewController
@synthesize tableList;
@synthesize checkoutDic;
@synthesize nowCoords;
@synthesize tablaData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tablaData = [[NSMutableArray alloc] init];
        self.selectCell = nil;
    }
    return self;
}

#pragma mark - log

- (void)viewWillAppear:(BOOL)animated{
    if (![CLLocationManager isLocationServiceEnabled]) {
        //        UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:@"请到“设置->隐私->定位服务”中开启定位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        //        [alet show];
        [self.tableList setTableStatus:STATUSFORNOGPS];
        [self stopAnimation];
        [self.tablaData removeAllObjects];
        [self.tableList reloadData];
        [self donePullDown];
        
        return;
    }
    if (self.tableList && !self.isLoading) {
        //        [self refreshGeo:nil];
        [self doRequest];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
     [[BrokerLogger sharedInstance] logWithActionCode:SIGNIN_LIST_ONVIEW page:SIGNIN_LIST note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    
    [self setTitleViewWithString:@"小区签到"];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI{
    self.map = [[MKMapView alloc] initWithFrame:CGRectZero];
    self.map.userInteractionEnabled = NO;
    self.map.showsUserLocation = YES;
    self.map.delegate = self;
    [self.view addSubview:self.map];
    
    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.frame = CGRectMake(0, 0, [self windowWidth], [self windowHeight]- STATUS_BAR_H - NAV_BAT_H-30);
    self.tableList.backgroundColor = [UIColor whiteColor];
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.tableList];
    [self autoPullDown];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [self windowHeight]-30- STATUS_BAR_H - NAV_BAT_H, [self windowWidth], 30)];
    bottomView.backgroundColor = [UIColor brokerBgPageColor];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    BrokerLineView *line = [[BrokerLineView alloc] init];
    line.horizontalLine = YES;
    line.frame = CGRectMake(0, 0, [self windowWidth], 0.5);
    [bottomView addSubview:line];
    
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 30)];
    tips.font = [UIFont ajkH5Font];
    tips.backgroundColor = [UIColor clearColor];
    tips.text = [NSString stringWithFormat:@"可签到%@米内小区",[LoginManager getSignMile]];
    tips.textColor = [UIColor brokerMiddleGrayColor];
    [bottomView addSubview:tips];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(235, 0, 60, 30);
    [btn setTitle:@"刷新位置" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont ajkH5Font];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:[UIColor brokerMiddleGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refreshGeo:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
    
    self.refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshBtn.frame = CGRectMake(295, 7, 15, 15);
    [self.refreshBtn addTarget:self action:@selector(refreshGeo:) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshBtn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.refreshBtn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateHighlighted];
    [bottomView addSubview:self.refreshBtn];
    
    [self addRightButton:@"规则" andPossibleTitle:nil];
    
    [self autoPullDown];
}

- (void)doBack:(id)sender{
    [super doBack:nil];
    [[BrokerLogger sharedInstance] logWithActionCode:SIGNIN_LIST_CLICK_BACK page:SIGNIN_LIST note:nil];
    
}

- (void)rightButtonAction:(id)sender{
    [[BrokerLogger sharedInstance] logWithActionCode:SIGNIN_LIST_CLICK_RULE page:SIGNIN_LIST note:nil];
    
    CheckoutWebViewController *webVC = [[CheckoutWebViewController alloc] init];
    webVC.webTitle = @"签到规则";
    webVC.webUrl = @"http://api.anjuke.com/web/nearby/brokersign/rule.html";
    
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)setStatusForNoGPS{
    [self donePullDown];
    
    [self.tablaData removeAllObjects];
    [self.tableList reloadData];
    [self.tableList setTableStatus:STATUSFORNOGPS];
    self.isLoading = NO;
    self.map.showsUserLocation = NO;
    [self stopAnimation];
}

#pragma mark - rotation method
- (void)refreshGeo:(id)sender{
     [[BrokerLogger sharedInstance] logWithActionCode:SIGNIN_LIST_CLICK_REFRESH page:SIGNIN_LIST note:nil];
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    [self autoPullDown];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 10000;
    
    [self.refreshBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    self.map.showsUserLocation = YES;
}

- (void)stopAnimation{
    [self.refreshBtn.layer removeAnimationForKey:@"rotationAnimation"];
}
#pragma mark - request method
- (void)doRequest{
    if (![CLLocationManager isLocationServiceEnabled]) {
        [self performSelector:@selector(setStatusForNoGPS) withObject:nil afterDelay:0.2];
        return;
    }
    if (![self isNetworkOkayWithNoInfo]) {

        [self.tableList setTableStatus:STATUSFORNETWORKERROR];

        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];

        [self.tablaData removeAllObjects];
        [self.tableList reloadData];

        [self performSelector:@selector(donePullDown) withObject:nil afterDelay:0.1];
        [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.1];

        self.isLoading = NO;
        return;
    }
    if ([CLLocationManager isLocationServiceEnabled] && !self.nowCoords.latitude) {
        //开始实时定位
        self.map.userInteractionEnabled = YES;

        [self performSelector:@selector(donePullDown) withObject:nil afterDelay:0.1];
        [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.1];

        [self.tablaData removeAllObjects];
        [self.tableList reloadData];
        self.isLoading = NO;
        return;
    }

    self.isLoading = YES;
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"latitude_specify"]) {
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude_specify"] doubleValue]],@"lat",[NSString stringWithFormat:@"%f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude_specify"] doubleValue]],@"lng", nil];
    }else{
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",self.nowCoords.latitude],@"lat",[NSString stringWithFormat:@"%f",self.nowCoords.longitude],@"lng", nil];
    }
    method = [NSString stringWithFormat:@"broker/commSignList/"];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}
//    if (![self isNetworkOkayWithNoInfo]) {
//        
//        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
//        
//        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
//        tapGes.delegate                = self;
//        tapGes.numberOfTouchesRequired = 1;
//        tapGes.numberOfTapsRequired    = 1;
//        [self.tableList.headerView addGestureRecognizer:tapGes];
//        
//        [self.tablaData removeAllObjects];
//        [self.tableList reloadData];
//        
//        [self performSelector:@selector(donePullDown) withObject:nil afterDelay:0.1];
//        [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.1];
//        
//        self.isLoading = NO;
//        return;
//    }
//    if ([CLLocationManager isLocationServiceEnabled] && !self.nowCoords.latitude) {
//        //开始实时定位
//        [self.locationManager startUpdatingLocation];
//        
//        [self performSelector:@selector(donePullDown) withObject:nil afterDelay:0.1];
//        [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.1];
//        
//        [self.tablaData removeAllObjects];
//        [self.tableList reloadData];
//        self.isLoading = NO;
//        return;
//    }
//    
//    self.isLoading = YES;
//    
//    NSMutableDictionary *params = nil;
//    NSString *method = nil;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"latitude_specify"]) {
//        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude_specify"] doubleValue]],@"lat",[NSString stringWithFormat:@"%f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude_specify"] doubleValue]],@"lng", nil];
//    }else{
//        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",self.nowCoords.latitude],@"lat",[NSString stringWithFormat:@"%f",self.nowCoords.longitude],@"lng", nil];
//    }
//    method = [NSString stringWithFormat:@"broker/commSignList/"];
//    
//    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
//}
- (void)onRequestFinished:(RTNetworkResponse *)response{
    self.isLoading = NO;
    [self stopAnimation];
    
    if([[response content] count] == 0){
        [self donePullDown];
        [self.tableList setTableStatus:STATUSFORNODATA];
       
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];

        
        [self.tablaData removeAllObjects];
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
        
        
        [self.tablaData removeAllObjects];
        [self.tableList reloadData];
        
        [self donePullDown];
        return;
    }
    
    self.tablaData = [[response content] objectForKey:@"data"];

    if (self.tablaData.count == 0) {
        [self.tableList setTableStatus:STATUSFORNODATA];
    }else{
        [self.tableList setTableStatus:STATUSFOROK];
    }
    [self.tableList reloadData];
    [self donePullDown];
}

#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tablaData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    CheckoutCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[CheckoutCommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    CheckCommunityModel *model = [CheckCommunityModel convertToMappedObject:[self.tablaData objectAtIndex:indexPath.row]];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    [cell configureCell:model withIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if (indexPath.row == self.tablaData.count - 1) {
        [cell showBottonLineWithCellHeight:46];
    }else{
        [cell showBottonLineWithCellHeight:46 andOffsetX:15];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.navigationController.view.frame.origin.x > 0) return;
    
    self.selectCell = indexPath;
    
     [[BrokerLogger sharedInstance] logWithActionCode:SIGNIN_LIST_CLICK_XIAOQU page:SIGNIN_LIST note:nil];
    
    CheckCommunityModel *model = [CheckCommunityModel convertToMappedObject:[self.tablaData objectAtIndex:indexPath.row]];
    CheckoutViewController *checkoutVC = [[CheckoutViewController alloc] init];
    
    checkoutVC.forbiddenEgo = YES;
    [checkoutVC passCommunityWithModel:model];
    [self.navigationController pushViewController:checkoutVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tapGus:(UITapGestureRecognizer *)gesture{
    [self autoPullDown];
}

#pragma mark MKMapViewDelegate -user location定位变化
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (![CLLocationManager isLocationServiceEnabled]) {
        [self performSelector:@selector(setStatusForNoGPS) withObject:nil afterDelay:0.2];
        
        return;
    }
    
    self.nowCoords = [userLocation coordinate];
    self.map.showsUserLocation = NO;
    [self doRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
