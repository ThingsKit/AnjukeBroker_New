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
#import "FootCell.h"

@interface CheckoutCommunityViewController ()<checkoutSuccussDelegate>
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
@property(nonatomic, assign) BOOL isHaveNextPage;
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation CheckoutCommunityViewController
@synthesize tableList;
@synthesize checkoutDic;
@synthesize nowCoords;
@synthesize tablaData;
@synthesize isHaveNextPage;
@synthesize pageNum;
@synthesize locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tablaData = [[NSMutableArray alloc] init];
        self.selectCell = nil;
        self.isHaveNextPage = NO;
        self.pageNum = 1;
    }
    return self;
}

#pragma mark - log

- (void)viewWillAppear:(BOOL)animated{
    if (![CLLocationManager isLocationServiceEnabled]) {
        [self.tableList setTableStatus:STATUSFORNOGPS];
        [self stopAnimation];
        [self.tablaData removeAllObjects];
        [self.tableList reloadData];
        [self donePullDown];
        
        return;
    }
}

- (CLLocationManager *)locationManager{
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        locationManager.delegate = self;
    }
    return locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BrokerLogger sharedInstance] logWithActionCode:COMMUNITY_CHECK_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];

    [self setTitleViewWithString:@"小区签到"];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)initUI{
    self.map = [[MKMapView alloc] initWithFrame:CGRectZero];
    self.map.userInteractionEnabled = NO;
//    self.map.showsUserLocation = YES;
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
    [[BrokerLogger sharedInstance] logWithActionCode:COMMUNITY_CHECK_006 note:nil];
    
}

- (void)rightButtonAction:(id)sender{
    [[BrokerLogger sharedInstance] logWithActionCode:COMMUNITY_CHECK_007 note:nil];
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
    [[BrokerLogger sharedInstance] logWithActionCode:COMMUNITY_CHECK_004 note:nil];
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

    //开始实时定位
    [self.locationManager startUpdatingLocation];
//    self.map.showsUserLocation = YES;
}

- (void)stopAnimation{
    [self.refreshBtn.layer removeAnimationForKey:@"rotationAnimation"];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations{
    [manager stopUpdatingLocation];
    
    if (![CLLocationManager isLocationServiceEnabled]) {
        [self performSelector:@selector(setStatusForNoGPS) withObject:nil afterDelay:0.2];
        
        return;
    }
    
    CLLocation * location = [locations lastObject];
    self.nowCoords = location.coordinate;
    DLog(@"self.nowCoords.latitude--->>%f",self.nowCoords.latitude);
    [self doRequest];
}

#pragma mark - request method
- (void)doRequest{
    if (![CLLocationManager isLocationServiceEnabled] && !self.nowCoords.latitude) {
        [self performSelector:@selector(setStatusForNoGPS) withObject:nil afterDelay:0.1];
        
        if (self.pageNum > 1) {
            self.pageNum =- 1;
        }
        return;
    }

    if (![self isNetworkOkayWithNoInfo]) {
        
        if (self.pageNum <= 1) {
            [self.tableList setTableStatus:STATUSFORNETWORKERROR];
            
            [self.tablaData removeAllObjects];
            [self.tableList reloadData];
        }
        
        if (self.pageNum > 1) {
            self.pageNum --;

            NSIndexPath * path = [NSIndexPath indexPathForRow:self.tablaData.count inSection:0];
            FootCell *lastCell = (FootCell *)[self.tableList cellForRowAtIndexPath:path];
            [lastCell setCellStatus:FootCellStatusForNetWorkError];
        }
        
        [self performSelector:@selector(donePullDown) withObject:nil afterDelay:0.1];
        [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.1];
        
        self.isLoading = NO;
        return;
    }
    if ([CLLocationManager isLocationServiceEnabled] && !self.nowCoords.latitude) {
        //开始实时定位
        [self.locationManager startUpdatingLocation];
        
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
- (void)onRequestFinished:(RTNetworkResponse *)response{
    self.isLoading = NO;
    [self stopAnimation];
    
    if([[response content] count] == 0){
        [self donePullDown];
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        [self.tablaData removeAllObjects];
        [self.tableList reloadData];

        if (self.pageNum > 1) {
            self.pageNum --;
        }

        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        [self.tablaData removeAllObjects];
        [self.tableList reloadData];

        [self donePullDown];

        if (self.pageNum > 1) {
            self.pageNum =- 1;
        }

        return;
    }
    
    NSMutableArray *receiveData = [[NSMutableArray alloc] initWithArray:[[response content] objectForKey:@"data"]];

    [self.tablaData addObjectsFromArray:receiveData];

    self.isHaveNextPage = YES;
    
    if (self.tablaData.count == 0) {
        [self.tableList setTableStatus:STATUSFORNODATA];
    }else{
        [self.tableList setTableStatus:STATUSFOROK];
    }
    [self donePullDown];
    [self.tableList reloadData];
}

- (void)checkedSuccuss{
    if (self.selectCell) {
        CheckoutCommunityCell *cell = (CheckoutCommunityCell *)[self.tableList cellForRowAtIndexPath:self.selectCell];
        [cell showCheckedStatus:YES];
        self.selectCell = nil;
    }
}

#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isHaveNextPage) {
        return self.tablaData.count+1;
    }else{
        return self.tablaData.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isHaveNextPage && indexPath.row == self.tablaData.count) {
        return 60;
    }
    return 46;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isHaveNextPage && indexPath.row == self.tablaData.count) {
        static NSString *identify = @"cell1";

        FootCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[FootCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        cell.cellStatus = FootCellStatusForNormal;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }

    static NSString *identify = @"cell2";
    CheckoutCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[CheckoutCommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    CheckCommunityModel *model = [CheckCommunityModel convertToMappedObject:[self.tablaData objectAtIndex:indexPath.row]];
    cell.contentView.backgroundColor = [UIColor whiteColor];

    [cell configureCell:model withIndex:indexPath.row];
    if (indexPath.row == self.tablaData.count - 1) {
        [cell showBottonLineWithCellHeight:46];
    }else{
        [cell showBottonLineWithCellHeight:46 andOffsetX:15];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.navigationController.view.frame.origin.x > 0) return;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == self.tablaData.count) {
        return;
    }
    
    self.selectCell = indexPath;
    
    [[BrokerLogger sharedInstance] logWithActionCode:COMMUNITY_CHECK_003 note:nil];
    CheckCommunityModel *model = [CheckCommunityModel convertToMappedObject:[self.tablaData objectAtIndex:indexPath.row]];
    CheckoutViewController *checkoutVC = [[CheckoutViewController alloc] init];
    checkoutVC.checkoutDelegate = self;
    
    checkoutVC.forbiddenEgo = YES;
    [checkoutVC passCommunityWithModel:model];
    [self.navigationController pushViewController:checkoutVC animated:YES];
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    DLog(@"scrollView---->>%f/%f",scrollView.contentOffset.y,scrollView.contentSize.height);
    if (self.isLoading || scrollView.contentSize.height == 0.0) {
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y < self.tableList.frame.size.height) {
        DLog(@"可以加载下一页了");
        self.isLoading = YES;
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.tablaData.count inSection:0];
        FootCell *lastCell = (FootCell *)[self.tableList cellForRowAtIndexPath:path];
        [lastCell setCellStatus:FootCellStatusForRefresh];

        self.pageNum ++;
        
        [self doRequest];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
