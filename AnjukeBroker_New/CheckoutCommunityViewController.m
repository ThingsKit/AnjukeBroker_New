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

    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    if (![CLLocationManager isLocationServiceEnabled]) {
        UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:@"请到“设置->隐私->定位服务”中开启定位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alet show];
    }
    [self refreshGeo:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.tableList.backgroundColor = [UIColor clearColor];
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.tableList];
    [self autoPullDown];

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [self windowHeight]-30- STATUS_BAR_H - NAV_BAT_H, [self windowWidth], 30)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 30)];
    tips.font = [UIFont ajkH5Font];
    tips.text = [NSString stringWithFormat:@"可签到%@米内小区",[LoginManager getSignMile]];
    tips.textColor = [UIColor brokerMiddleGrayColor];
    [bottomView addSubview:tips];
    
    UILabel *refreshTips = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 60, 30)];
    refreshTips.font = [UIFont ajkH5Font];
    refreshTips.text = @"刷新位置";
    refreshTips.textColor = [UIColor brokerMiddleGrayColor];
    [bottomView addSubview:refreshTips];
    
    self.refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshBtn.frame = CGRectMake(280, 5, 20, 20);
    [self.refreshBtn addTarget:self action:@selector(refreshGeo:) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshBtn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.refreshBtn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateHighlighted];
    [bottomView addSubview:self.refreshBtn];
    
    [self autoPullDown];
}

- (void)refreshGeo:(id)sender{
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

- (void)doRequest{
    if (!self.nowCoords.latitude) {
        self.isLoading = NO;
        return;
    }
    if (![self isNetworkOkay]) {
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        [self.tableList reloadData];
        self.isLoading = NO;
        return;
    }
    self.isLoading = YES;
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",self.nowCoords.latitude],@"lat",[NSString stringWithFormat:@"%f",self.nowCoords.longitude],@"lng", nil];
    method = [NSString stringWithFormat:@"broker/commSignList/"];

    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}
- (void)onRequestFinished:(RTNetworkResponse *)response{
    self.isLoading = NO;
    [self stopAnimation];
    
    if([[response content] count] == 0){
        [self donePullDown];
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        [self.tableList reloadData];

        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        DLog(@"errorMsg--->>%@",errorMsg);

        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        [self.tableList reloadData];

        [self donePullDown];
        return;
    }
    
    self.tablaData = [[response content] objectForKey:@"data"];
    DLog(@"self.tablaData-->>%@",self.tablaData);
    if (self.tablaData.count == 0) {
        [self.tableList setTableStatus:STATUSFORNODATA];
    }
    [self donePullDown];
    [self.tableList reloadData];
}

#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tablaData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";    
    CheckoutCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[CheckoutCommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    CheckCommunityModel *model = [CheckCommunityModel convertToMappedObject:[self.tablaData objectAtIndex:indexPath.row]];

    [cell configureCell:model withIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if (indexPath.row == self.tablaData.count - 1) {
        [cell showBottonLineWithCellHeight:45];
    }else{
        [cell showBottonLineWithCellHeight:45 andOffsetX:15];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.navigationController.view.frame.origin.x > 0) return;

    CheckCommunityModel *model = [CheckCommunityModel convertToMappedObject:[self.tablaData objectAtIndex:indexPath.row]];
    CheckoutViewController *checkoutVC = [[CheckoutViewController alloc] init];
    [AppDelegate sharedAppDelegate].checkoutVC = checkoutVC;
    checkoutVC.forbiddenEgo = YES;
    [checkoutVC passCommunityWithModel:model];
    [self.navigationController pushViewController:checkoutVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MKMapViewDelegate -user location定位变化
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    self.nowCoords = [userLocation coordinate];
    self.map.showsUserLocation = NO;
    [self doRequest];
}

@end
