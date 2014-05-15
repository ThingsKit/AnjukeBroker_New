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
#import "MBProgressHUD.h"

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
@property(nonatomic, assign) int loadCount;
@property(nonatomic, strong) CheckCommunityModel *checkCommunitmodel;
@property(nonatomic, strong) NSArray *checkTimeArr;//签到时间段
@property(nonatomic, strong) NSString *signMile;
@property(nonatomic, strong) NSMutableArray *checkCellStatusArr;
@property(nonatomic, strong) UILabel *checkoutNumLab;
@property(nonatomic, strong) CheckInfoWithCommunity *checkInfoModel;
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) UILabel *hudLabel;
@end

//self.hudLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 115, 155, 20)];
//self.hudLabel.font = [UIFont systemFontOfSize:15];
//self.hudLabel.backgroundColor = [UIColor clearColor];
//self.hudLabel.textColor = [UIColor whiteColor];
//self.hudLabel.textAlignment = NSTextAlignmentCenter;
@implementation CheckoutViewController
@synthesize headerView;
@synthesize checkoutBtn;
@synthesize cb;
@synthesize nowCoords;
@synthesize isLoading;
@synthesize loadCount;
@synthesize checkCommunitmodel;
@synthesize checkTimeArr;
@synthesize signMile;
@synthesize checkCellStatusArr;
@synthesize checkoutNumLab;
@synthesize checkInfoModel;
@synthesize hud;
@synthesize hudLabel;

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
    
    MKMapView *map = [[MKMapView alloc] initWithFrame:HEADERMAPFRAME];
    map.userInteractionEnabled = NO;
    map.showsUserLocation = YES;
    map.delegate = self;
    [self.headerView addSubview:map];

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
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",self.nowCoords.latitude],@"lat",[NSString stringWithFormat:@"%f",self.nowCoords.longitude],@"lng",self.checkCommunitmodel.commId,@"commId", nil];
    method = [NSString stringWithFormat:@"broker/commSignDetail/"];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}

- (void)onRequestFinished:(RTNetworkResponse *)response{
    if([[response content] count] == 0){
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        DLog(@"errorMsg--->>%@",errorMsg);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
        self.isLoading = NO;
        [self donePullDown];
        return;
    }
    self.loadCount += 1;
    
    NSDictionary *dic = [[response content] objectForKey:@"data"];
    self.checkInfoModel = [[CheckInfoWithCommunity alloc] convertToMappedObject:dic];
    [self updateUI];
}
- (void)updateUI{
    if (self.checkInfoModel.signCount) {
        self.checkoutNumLab.text = [NSString stringWithFormat:@"%d人\n今日已签",[self.checkInfoModel.signCount intValue]];
    }
    
//    NSDictionary *checkInfoDic = [[NSDictionary alloc] initWithDictionary:self.checkInfoModel.signList];
//    NSArray *sortKeys = [timeArrSort arrSort:checkInfoDic.allKeys];
//    for (int i = 0 ; i < sortKeys.count; i++) {
//        NSString *key = [sortKeys objectAtIndex:i];
//        NSArray *timeAreaArr = checkInfoDic[key];
//        
//        if (timeAreaArr.count != 0) {
//            [self.checkCellStatusArr replaceObjectAtIndex:i+1 withObject:[NSNumber numberWithInt:CHECKOUTCELLWITHCHCK]];
//        }
//    }
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
        self.checkoutBtn = [self.cb buttonWithCountdown:[self.checkInfoModel.signCount intValue]];
        self.checkoutBtn.frame = CGRectMake(15, 150 + 15, 220, 40);
        [self.headerView addSubview:self.checkoutBtn];
    }else{
        self.checkoutBtn = [self.cb buttonWithNormalStatus];
        self.checkoutBtn.frame = CGRectMake(15, 150 + 15, 220, 40);
        [self.headerView addSubview:self.checkoutBtn];
        [self.checkoutBtn addTarget:self action:@selector(checkoutCommunity:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.tableList reloadData];
}
- (void)doCheckActionRequest{
    if (!self.nowCoords.latitude) {
        return;
    }
    
    if ([self calcDistance] > [self.signMile integerValue]) {
        [self showInfo:@"您漂移的太远"];
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",self.nowCoords.latitude],@"lat",[NSString stringWithFormat:@"%f",self.nowCoords.longitude],@"lng",@"",@"commId", nil];
    method = [NSString stringWithFormat:@"broker/commSign/"];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onCheckActionRequestFinished:)];
}
- (void)onCheckActionRequestFinished:(RTNetworkResponse *)response{
    if([[response content] count] == 0){
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        DLog(@"errorMsg--->>%@",errorMsg);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
        self.isLoading = NO;
        [self donePullDown];

        [self showInfo:@"签到失败"];
        return;
    }
    
    NSDictionary *dic = [response content];
    if ([dic[@"status"] isEqualToString:@"ok"]) {
        [self showInfo:@"签到成功"];
        self.checkoutBtn = [self.cb buttonWithCountdown:[[[dic objectForKey:@"data"] objectForKey:@"countDown"] intValue]];
        self.checkoutBtn.frame = CGRectMake(15, 150 + 15, 220, 40);
        [self.headerView addSubview:self.checkoutBtn];

        [self doRequest];
    }else{
        [self showInfo:@"签到失败"];
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
    if (self.loadCount == 0 && self.isLoading == NO) {
        [self doRequest];
    }
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
    
    if (self.tableList) {
        [self autoPullDown];
    }
}
- (void)rightButtonAction:(id)sender{
    CheckoutRuleViewController *ruleVC = [[CheckoutRuleViewController alloc] init];
    [self.navigationController pushViewController:ruleVC animated:YES];
}

//使用 MBProgressHUD
- (void)showHUDWithTitle:(NSString*)title CustomView:(UIView*)view IsDim:(BOOL)isDim {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor clearColor];
    self.hud.customView = view;
    self.hud.yOffset = -20;
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.dimBackground = isDim;
    self.hudLabel.text = title;
    
}

//使用 MBProgressHUD 显示完成提示
- (void)showHUDWithTitle:(NSString *)title CustomView:(UIView *)view IsDim:(BOOL)isDim IsHidden:(BOOL)isHidden{
    
    [self showHUDWithTitle:title CustomView:view IsDim:isDim];
    if (isHidden) {
        [self.hud hide:YES afterDelay:1];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
