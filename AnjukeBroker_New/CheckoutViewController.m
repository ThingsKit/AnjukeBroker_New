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

#define HEADERFRAME CGRectMake(0, 0, [self windowWidth], 220)
#define HEADERMAPFRAME CGRectMake(0, 0, [self windowWidth], 150)
#define FRAME_CENTRE_LOC CGRectMake([self windowWidth]/2-8, 150/2-25, 16, 33)
#define CELLHEIGHT_NOFMAL 44
#define CELLHEIGHT_NOCHECK 60
#define CELLHEIGHT_CHECK 100

@interface CheckoutViewController ()<checkoutButtonDelegate>
@property(nonatomic, strong) UITableView *tableList;
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UIButton *checkoutBtn;
@property(nonatomic, strong) CheckoutButton *cb;
//user最新2d
@property(nonatomic,assign) CLLocationCoordinate2D nowCoords;

@end

@implementation CheckoutViewController
@synthesize tableList;
@synthesize headerView;
@synthesize checkoutBtn;
@synthesize cb;
@synthesize nowCoords;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cb = [[CheckoutButton alloc] init];
        cb.checkoutDelegate = self;
    }
    return self;
}
- (void)dealloc{
    self.cb.checkoutDelegate = nil;
    self.cb = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRightButton:@"规则" andPossibleTitle:nil];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)initUI{
    self.tableList = [[BrokerTableStuct alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
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
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(39.915352,116.397105);
    float zoomLevel = 0.02;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    region = [map regionThatFits:region];
    [map setRegion:region animated:NO];

    //签到按钮
//    self.checkoutBtn = [self.cb buttonWithCountdown:15];
//    self.checkoutBtn.frame = CGRectMake(15, map.frame.size.height + 15, 220, 40);
//    [self.headerView addSubview:self.checkoutBtn];

    self.checkoutBtn = [CheckoutButton buttonWithNormalStatus];
    [self.checkoutBtn addTarget:self action:@selector(checkoutCommunity:) forControlEvents:UIControlEventTouchUpInside];
    self.checkoutBtn.frame = CGRectMake(15, map.frame.size.height + 15, 220, 40);
    [self.headerView addSubview:self.checkoutBtn];
    
    UILabel *checkoutNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.checkoutBtn.frame.origin.x+self.checkoutBtn.frame.size.width, self.checkoutBtn.frame.origin.y, 80, 40)];
    checkoutNumLab.lineBreakMode = UILineBreakModeWordWrap;
    checkoutNumLab.numberOfLines = 0;
    checkoutNumLab.text = [NSString stringWithFormat:@"33人\n今日已签"];
    checkoutNumLab.font = [UIFont systemFontOfSize:14];
    checkoutNumLab.textAlignment = NSTextAlignmentCenter;
    checkoutNumLab.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:checkoutNumLab];
    
    self.tableList.tableHeaderView = self.headerView;
}
- (void)checkoutCommunity:(id)sender{
    
}
- (void)timeCountZero{
    if (self.checkoutBtn) {
        [self.checkoutBtn removeFromSuperview];
        self.checkoutBtn = nil;
    }
    self.checkoutBtn = [CheckoutButton buttonWithUnCheck];
    self.checkoutBtn.frame = CGRectMake(15, 150 + 15, 220, 40);
    [self.headerView addSubview:self.checkoutBtn];
}
#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return CELLHEIGHT_NOFMAL;
        case 1:
            return CELLHEIGHT_NOCHECK;
        case 2:
            return CELLHEIGHT_CHECK;
        case 3:
            return CELLHEIGHT_NOCHECK;
        case 4:
            return CELLHEIGHT_NOFMAL;
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
    
    if (indexPath.row == 0) {
        [cell showTopLine];
        [cell configurCell:nil withIndex:indexPath.row cellType:CHECKOUTCELLWITHELSE];
    }else if (indexPath.row == 1){
        [cell showTopLine];
        [cell configurCell:nil withIndex:indexPath.row cellType:CHECKOUTCELLWITHNOCHECK];
        [cell showBottonLineWithCellHeight:CELLHEIGHT_NOCHECK andOffsetX:15];
    }else if (indexPath.row == 2){
        [cell configurCell:nil withIndex:indexPath.row cellType:CHECKOUTCELLWITHCHCK];
        [cell showBottonLineWithCellHeight:CELLHEIGHT_CHECK andOffsetX:15];
    }else if (indexPath.row == 3){
        [cell configurCell:nil withIndex:indexPath.row cellType:CHECKOUTCELLWITHNOCHECK];
        [cell showBottonLineWithCellHeight:CELLHEIGHT_NOCHECK];
    }else if (indexPath.row == 4){
        [cell configurCell:nil withIndex:indexPath.row cellType:CHECKOUTCELLWITHELSE];
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
    DLog(@"updateLocation111--->>%f/%f,",self.nowCoords.latitude,self.nowCoords.longitude);

}

- (void)passCommunityDic:(NSDictionary *)dic{
    [self setTitleViewWithString:@"签到-东方曼哈顿"];
}
- (void)rightButtonAction:(id)sender{
    CheckoutRuleViewController *ruleVC = [[CheckoutRuleViewController alloc] init];
    [self.navigationController pushViewController:ruleVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
