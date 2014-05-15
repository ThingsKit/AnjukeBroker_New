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

@interface CheckoutCommunityViewController ()
//@property(nonatomic, strong) CheckCommunityTable *tableList;
@property(nonatomic, strong) NSDictionary *checkoutDic;
//user最新2d
@property(nonatomic, assign) CLLocationCoordinate2D nowCoords;
@property(nonatomic ,strong) NSMutableArray *tablaData;
@property(nonatomic, assign) BOOL isLoading;
@property(nonatomic, assign) int loadCount;

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
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"小区签到"];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)initUI{
    MKMapView *map = [[MKMapView alloc] initWithFrame:CGRectZero];
    map.userInteractionEnabled = NO;
    map.showsUserLocation = YES;
    map.delegate = self;
    [self.view addSubview:map];

    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.backgroundColor = [UIColor clearColor];
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.tableList];

    [self autoPullDown];
}

- (void)doRequest{
    if (!self.nowCoords.latitude) {
//        [[HUDNews sharedHUDNEWS] createHUD:@"暂未获取地理信息" hudTitleTwo:nil addView:self.view isDim:YES isHidden:YES statusOK:NO];
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
    DLog(@"tokenValue--->>%@",[LoginManager getToken]);
    params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",self.nowCoords.latitude],@"lat",[NSString stringWithFormat:@"%f",self.nowCoords.longitude],@"lng", nil];
    method = [NSString stringWithFormat:@"broker/commSignList/"];

    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}
- (void)onRequestFinished:(RTNetworkResponse *)response{
    self.isLoading = NO;
    self.loadCount += 1;
    DLog(@"。。。response [%@]", [response content]);
    if([[response content] count] == 0){
        self.isLoading = NO;
        [self donePullDown];
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        [self.tableList reloadData];

        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        DLog(@"errorMsg--->>%@",errorMsg);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
//        [alert show];
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        [self.tableList reloadData];

        self.isLoading = NO;
        [self donePullDown];
        return;
    }
    
    self.tablaData = [[response content] objectForKey:@"data"];
    if (self.tablaData.count == 0) {
        [self.tableList setTableStatus:STATUSFORNODATA];
    }
    DLog(@"self.tablaData-->>%@",self.tablaData);
    self.isLoading = NO;
    [self donePullDown];
    [self.tableList reloadData];
}

#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tablaData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";    
    CheckoutCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[CheckoutCommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }

    [cell configureCell:self.tablaData withIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if (indexPath.row == self.tablaData.count - 1) {
        [cell showBottonLineWithCellHeight:CELL_HEIGHT];
    }else{
        [cell showBottonLineWithCellHeight:CELL_HEIGHT andOffsetX:15];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.navigationController.view.frame.origin.x > 0) return;

    CheckCommunityModel *model = [[CheckCommunityModel alloc] convertToMappedObject:[self.tablaData objectAtIndex:indexPath.row]];
    CheckoutViewController *checkoutVC = [[CheckoutViewController alloc] init];
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
    DLog(@"updateLocation--->>%f/%f,",self.nowCoords.latitude,self.nowCoords.longitude);

    if (self.loadCount == 0) {
        [self doRequest];
    }
}

@end
