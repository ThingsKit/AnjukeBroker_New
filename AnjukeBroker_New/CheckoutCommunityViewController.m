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

@interface CheckoutCommunityViewController ()
@property(nonatomic, strong) BrokerTableStuct *tableList;
@property(nonatomic, strong) NSDictionary *checkoutDic;
//user最新2d
@property(nonatomic,assign) CLLocationCoordinate2D nowCoords;

@end

@implementation CheckoutCommunityViewController
@synthesize tableList;
@synthesize checkoutDic;
@synthesize nowCoords;

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
    [self setTitleViewWithString:@"小区签到"];
    
    self.tableList = [[BrokerTableStuct alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.backgroundColor = [UIColor clearColor];
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.tableList];

//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    view.backgroundColor = [UIColor blackColor];
//    [self.tableList setTableStatus:view status:STATUSFORNETWORKERROR];

    // Do any additional setup after loading the view.
}
#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
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
    [cell configureCell:nil withIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell showBottonLineWithCellHeight:CELL_HEIGHT andOffsetX:15];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.navigationController.view.frame.origin.x > 0) return;

    CheckoutViewController *checkoutVC = [[CheckoutViewController alloc] init];
    [checkoutVC passCommunityDic:nil];
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
}

@end
