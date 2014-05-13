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
#import "UIButton+Checkout.h"

#define HEADERFRAME CGRectMake(0, 0, [self windowWidth], 250)
#define HEADERMAPFRAME CGRectMake(0, 0, [self windowWidth], 150)

@interface CheckoutViewController ()
@property(nonatomic, strong) UITableView *tableList;
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UIButton *checkoutBtn;
@end

@implementation CheckoutViewController
@synthesize tableList;
@synthesize headerView;
@synthesize checkoutBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    self.tableList.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.tableList];
    
    self.headerView = [[UIView alloc] initWithFrame:HEADERFRAME];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    MKMapView *map = [[MKMapView alloc] initWithFrame:HEADERMAPFRAME];
    map.userInteractionEnabled = NO;
    map.delegate = self;
    [self.headerView addSubview:map];

    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(39.915352,116.397105);
    float zoomLevel = 0.1;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    region = [map regionThatFits:region];
    [map setRegion:region animated:NO];

    self.checkoutBtn = [UIButton buttonWithNormalStatus];
    self.checkoutBtn.frame = CGRectMake(20, map.frame.size.height + 25, 200, 60);
    [self.headerView addSubview:self.checkoutBtn];
    
    UILabel *checkoutNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.checkoutBtn.frame.origin.x+self.checkoutBtn.frame.size.width+20, self.checkoutBtn.frame.origin.y, 80, 60)];
    checkoutNumLab.lineBreakMode = UILineBreakModeWordWrap;
    checkoutNumLab.numberOfLines = 0;
    checkoutNumLab.text = [NSString stringWithFormat:@"33人\n今日已签"];
    checkoutNumLab.font = [UIFont systemFontOfSize:14];
    checkoutNumLab.textAlignment = NSTextAlignmentCenter;
    checkoutNumLab.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:checkoutNumLab];
    
    self.tableList.tableHeaderView = self.headerView;
}

//CLLocation *loc = [[CLLocation alloc] initWithLatitude:naviCoordsGd.latitude longitude:naviCoordsGd.longitude];
//MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(naviCoordsGd, 500, 500);
//self.naviRegion = [self.regionMapView regionThatFits:viewRegion];
//
//[self.regionMapView setRegion:self.naviRegion animated:NO];
//[self showAnnotation:loc coord:naviCoordsGd];

#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CheckoutCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[CheckoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    [cell configureCell:nil withIndex:indexPath.row];
    [cell showBottonLineWithCellHeight:CELL_HEIGHT-1 andOffsetX:15];
    
    return cell;
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
