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
#import "CheckoutRuleViewController.h"
#import "CheckoutButton.h"
#import "CLLocationManager+RT.h"
#import "timeArrSort.h"
#import "CheckInfoWithCommunity.h"
#import "HUDNews.h"

#define HEADERFRAME CGRectMake(0, 0, [self windowWidth], 220)
#define HEADERMAPFRAME CGRectMake(0, 0, [self windowWidth], 150)
#define FRAME_CENTRE_LOC CGRectMake([self windowWidth]/2-8, 150/2-25, 16, 33)
#define CELLHEIGHT_NOFMAL 44
#define CELLHEIGHT_NOCHECK 60
#define CELLHEIGHT_CHECK 100

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cb = [[CheckoutButton alloc] init];
        cb.checkoutDelegate = self;
        
        self.checkTimeArr = [[NSArray alloc] initWithArray:[LoginManager getCheckTimeArr]];
        self.signMile = [NSString stringWithFormat:@"%@",[LoginManager getSignMile]];
        self.checkCellStatusArr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:CHECKOUTCELLWITHELSE],[NSNumber numberWithInt:CHECKOUTCELLWITHNOCHECK],[NSNumber numberWithInt:CHECKOUTCELLWITHNOCHECK],[NSNumber numberWithInt:CHECKOUTCELLWITHNOCHECK],[NSNumber numberWithInt:CHECKOUTCELLWITHELSE], nil];
        self.hideCheck = NO;
    }
    return self;
}
- (void)dealloc{
    self.cb.checkoutDelegate = nil;
    self.cb = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [self locationServiceCheck];
}
- (void)locationServiceCheck{
    if (![CLLocationManager isLocationServiceEnabled]) {
        UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:@"请到“设置->隐私->定位服务”中开启定位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alet show];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRightButton:@"规则" andPossibleTitle:nil];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)initUI{    
    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.backgroundColor = [UIColor clearColor];
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableList];
    
    self.headerView = [[UIView alloc] initWithFrame:HEADERFRAME];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 50)];
    footView.backgroundColor = [UIColor whiteColor];
    self.tableList.tableFooterView = footView;
    
    self.map = [[MKMapView alloc] initWithFrame:HEADERMAPFRAME];
    self.map.userInteractionEnabled = NO;
    self.map.showsUserLocation = YES;
    self.map.delegate = self;
    [self.headerView addSubview:self.map];

    UIImageView *certerIcon = [[UIImageView alloc] initWithFrame:FRAME_CENTRE_LOC];
    certerIcon.image = [UIImage imageNamed:@"anjuke_icon_itis_position.png"];
    [map addSubview:certerIcon];
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(self.checkCommunitmodel.lat,self.checkCommunitmodel.lng);
    float zoomLevel = 0.02;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    region = [map regionThatFits:region];
    [map setRegion:region animated:NO];

    //签到按钮
    self.checkoutBtn = [self.cb buttonWithUnCheck];
    self.checkoutBtn.frame = CGRectMake(15, map.frame.size.height + 15, 220, 40);
    [self.headerView addSubview:self.checkoutBtn];
    
    self.checkoutNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.checkoutBtn.frame.origin.x+self.checkoutBtn.frame.size.width, self.checkoutBtn.frame.origin.y, 80, 40)];
    self.checkoutNumLab.lineBreakMode = UILineBreakModeWordWrap;
    self.checkoutNumLab.numberOfLines = 0;
    self.checkoutNumLab.text = [NSString stringWithFormat:@"-人\n今日已签"];
    self.checkoutNumLab.font = [UIFont systemFontOfSize:14];
    self.checkoutNumLab.textAlignment = NSTextAlignmentCenter;
    self.checkoutNumLab.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:self.checkoutNumLab];
    
    self.tableList.tableHeaderView = self.headerView;
}
- (void)checkoutCommunity:(id)sender{
    [self doCheckActionRequest];
}

- (void)doRequest{
    [self locationServiceCheck];

    if (!self.nowCoords.latitude) {
        [self donePullDown];
        return;
    }
    if (![self isNetworkOkay]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:YES isHidden:YES statusOK:NO];
        self.isLoading = NO;
        return;
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;

    params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",self.nowCoords.latitude],@"lat",[NSString stringWithFormat:@"%f",self.nowCoords.longitude],@"lng",self.checkCommunitmodel.commId,@"commId", nil];
    DLog(@"paramsparam----->>%@",params);
    method = [NSString stringWithFormat:@"broker/commSignDetail/"];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}

- (void)onRequestFinished:(RTNetworkResponse *)response{
    if([[response content] count] == 0){
        self.isLoading = NO;
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:YES isHidden:YES statusOK:NO];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        DLog(@"errorMsg--->>%@",errorMsg);

        [[HUDNews sharedHUDNEWS] createHUD:@"服务器开溜了" hudTitleTwo:nil addView:self.view isDim:YES isHidden:YES statusOK:NO];
        self.isLoading = NO;

        return;
    }
    
    NSDictionary *dic = [[response content] objectForKey:@"data"];
    DLog(@"checkInfoDic--->>%@",dic)

    self.checkInfoModel = [CheckInfoWithCommunity convertToMappedObject:dic];

    if (self.checkInfoModel.signList.count == 0) {
        self.hideCheck = YES;
    }else{
        self.hideCheck = NO;
    }
    
    
    [self updateUI];
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
    //更新签到状态
    if (self.checkoutBtn) {
        [self.checkoutBtn removeFromSuperview];
    }
    if ([self.checkInfoModel.signAble intValue] == 1) {
        self.checkoutBtn = [self.cb buttonWithCountdown:[self.checkInfoModel.countDown intValue]];
        self.checkoutBtn.frame = CGRectMake(15, 150 + 15, 220, 40);
        [self.headerView addSubview:self.checkoutBtn];
    }else{
        self.checkoutBtn = [self.cb buttonWithCountdown:[self.checkInfoModel.countDown intValue]];
        self.checkoutBtn.frame = CGRectMake(15, 150 + 15, 220, 40);
        [self.headerView addSubview:self.checkoutBtn];

//        self.checkoutBtn = [self.cb buttonWithNormalStatus];
//        self.checkoutBtn.frame = CGRectMake(15, 150 + 15, 220, 40);
//        [self.headerView addSubview:self.checkoutBtn];
//        [self.checkoutBtn addTarget:self action:@selector(checkoutCommunity:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.tableList reloadData];
}
- (void)doCheckActionRequest{
    if (!self.nowCoords.latitude) {
        return;
    }
    if (![self isNetworkOkay]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:YES isHidden:YES statusOK:NO];
        self.isLoading = NO;
        return;
    }
    if ([self calcDistance] > [self.signMile integerValue]) {
          [[HUDNews sharedHUDNEWS] createHUD:@"您漂移的太远" hudTitleTwo:nil addView:self.view isDim:YES isHidden:YES statusOK:YES];
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",self.nowCoords.latitude],@"lat",[NSString stringWithFormat:@"%f",self.nowCoords.longitude],@"lng",self.checkCommunitmodel.commId,@"commId", nil];
    method = [NSString stringWithFormat:@"broker/commSign/"];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onCheckActionRequestFinished:)];
}
- (void)onCheckActionRequestFinished:(RTNetworkResponse *)response{
    if([[response content] count] == 0){
        self.isLoading = NO;
//        [self showInfo:@"操作失败"];
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:YES isHidden:YES statusOK:NO];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        DLog(@"errorMsg--->>%@",errorMsg);

        [[HUDNews sharedHUDNEWS] createHUD:@"服务器开溜了" hudTitleTwo:@"签到失败" addView:self.view isDim:YES isHidden:YES statusOK:NO];
        self.isLoading = NO;

        return;
    }
    
    NSDictionary *dic = [response content];
    DLog(@"checkReturnDic---->>%@",dic);
    if ([dic[@"status"] isEqualToString:@"ok"]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"签到成功" hudTitleTwo:nil addView:self.view isDim:YES isHidden:YES statusOK:YES];
        self.checkoutBtn = [self.cb buttonWithCountdown:[[[dic objectForKey:@"data"] objectForKey:@"countDown"] intValue]];
        self.checkoutBtn.frame = CGRectMake(15, 150 + 15, 220, 40);
        [self.headerView addSubview:self.checkoutBtn];

        [self doRequest];
    }else{
        [[HUDNews sharedHUDNEWS] createHUD:@"签到失败" hudTitleTwo:nil addView:self.view isDim:YES isHidden:YES statusOK:NO];
    }
}
- (void)timeCountZero{
    if (self.checkoutBtn) {
        [self.checkoutBtn removeFromSuperview];
        self.checkoutBtn = nil;
    }
    self.checkoutBtn = [self.cb buttonWithNormalStatus];
    self.checkoutBtn.frame = CGRectMake(15, 150 + 15, 220, 40);
    [self.checkoutBtn addTarget:self action:@selector(checkoutCommunity:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.checkoutBtn];
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
    
    //分割线绘制
    if (indexPath.row == 0) {
        [cell showTopLine];
    }else if (indexPath.row == 1){
        [cell showTopLine];
        if ([[self.checkCellStatusArr objectAtIndex:indexPath.row] intValue] == CHECKOUTCELLWITHNOCHECK) {
            [cell showBottonLineWithCellHeight:CELLHEIGHT_NOCHECK andOffsetX:15];
        }else{
            [cell showBottonLineWithCellHeight:CELLHEIGHT_CHECK andOffsetX:15];
        }
    }else if (indexPath.row == 2){
        if ([[self.checkCellStatusArr objectAtIndex:indexPath.row] intValue] == CHECKOUTCELLWITHNOCHECK) {
            [cell showBottonLineWithCellHeight:CELLHEIGHT_NOCHECK andOffsetX:15];
        }else{
            [cell showBottonLineWithCellHeight:CELLHEIGHT_CHECK andOffsetX:15];
        }
    }else if (indexPath.row == 3){
        if ([[self.checkCellStatusArr objectAtIndex:indexPath.row] intValue] == CHECKOUTCELLWITHNOCHECK) {
            [cell showBottonLineWithCellHeight:CELLHEIGHT_NOCHECK];
        }else{
            [cell showBottonLineWithCellHeight:CELLHEIGHT_CHECK];
        }
    }else if (indexPath.row == 4){
        [cell showBottonLineWithCellHeight:CELLHEIGHT_NOFMAL];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.navigationController.view.frame.origin.x > 0)
        return;

    if (indexPath.row == 4) {
        [self rightButtonAction:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark MKMapViewDelegate -user location定位变化
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    self.nowCoords = [userLocation coordinate];
    self.map.showsUserLocation = NO;
    [self doRequest];
    DLog(@"updateLocation111--->>%f/%f,",self.nowCoords.latitude,self.nowCoords.longitude);
}
- (CLLocationDistance)calcDistance{
    CLLocation *communityLoc = [[CLLocation alloc] initWithLatitude:self.checkCommunitmodel.lat  longitude:self.checkCommunitmodel.lng];
    CLLocation *nowLoc = [[CLLocation alloc] initWithLatitude:self.nowCoords.latitude longitude:self.nowCoords.longitude];
    
    CLLocationDistance kilometers = [communityLoc distanceFromLocation:nowLoc]/1000;
    NSLog(@"距离:--->>%f",kilometers);
    return kilometers;
}
- (void)passCommunityWithModel:(CheckCommunityModel *)model;{
    self.checkCommunitmodel = model;
    
    [self setTitleViewWithString:self.checkCommunitmodel.commName];
}
- (void)rightButtonAction:(id)sender{
    [self doRequest];
//    CheckoutRuleViewController *ruleVC = [[CheckoutRuleViewController alloc] init];
//    [self.navigationController pushViewController:ruleVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
