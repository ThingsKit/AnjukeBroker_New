//
//  BrokerRegisterWorkCityViewController.m
//  AnjukeBroker_New
//
//  Created by jason on 6/25/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "BrokerRegisterWorkCityViewController.h"
#import "CityModel.h"
#import "LocationManager.h"
#import "AXNetWorkResponse.h"
#import <RTLineView.h>

@interface BrokerRegisterWorkCityViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *cityData;
@property(nonatomic,strong) NSArray *indexArray;
@property(nonatomic) BOOL isLocatedSuccess;

@end

@implementation BrokerRegisterWorkCityViewController

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
    

    [self initCityDataArray];
    [self requestCityData];
    [self setTitleViewWithString:@"所在城市"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIView navigationControllerBound] style:UITableViewStyleGrouped];
    tableView.dataSource   = self;
    tableView.delegate     = self;
    tableView.rowHeight    = 45;
    tableView.sectionHeaderHeight = 0;
    tableView.sectionFooterHeight = 0;
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    tableView.sectionIndexColor           = [UIColor brokerBabyBlueColor];
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    
    NSLog(@"%d",[tableView subviews].count);
    
}

- (void)initCityDataArray
{
    //  获取GPS定位城市
    NSString *cityID     = [[RTLocationManager sharedInstance] locatedCityID];
    if (![cityID isEqual:@"-1"]) {
        [[RTCityInfoManager sharedInstance] setServiceType:RTAnjukeServiceID];
        RTCityInfo *cityInfo  = [[RTCityInfoManager sharedInstance] cityInfoWithCityID:cityID];
        self.cityData         = @[[[CityModel alloc] initWithTitle:@"GPS定位城市" cityArray:@[@{@"cityId":cityID,@"cityName":cityInfo.cityName}]]];
        self.isLocatedSuccess = true;
    } else {
        self.cityData         = @[[[CityModel alloc] initWithTitle:@"GPS定位城市" cityArray:@[@{@"cityId":cityID,@"cityName":@"未知"}]]];
        self.isLocatedSuccess = false;
    }
    
    //  初始化tableView的索引
    NSMutableArray *indexArray = [NSMutableArray arrayWithArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    [indexArray removeLastObject];
    
    // 初始化tableView的数据源
    NSMutableArray *cityArray  = [NSMutableArray array];
    for (NSString *index in indexArray) {
        CityModel *city  = [[CityModel alloc] initWithTitle:index cityArray:[NSArray array]];
        [cityArray addObject:city];
    }
    self.cityData   = [self.cityData arrayByAddingObjectsFromArray:cityArray];
    self.indexArray = [@[@"#"] arrayByAddingObjectsFromArray:indexArray];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[RTLocationManager sharedInstance] updateLocatedCityID];
}

- (void)requestCityData
{
    NSString     *method = @"common/cities/";
    NSDictionary *params  = nil;//@{@"is_nocheck":@"1"};
    [[RTRequestProxy sharedInstance]asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(handleCityData:)];
}

- (void)handleCityData:(RTNetworkResponse *)response
{
    if (response.status == RTNetworkResponseStatusFailed) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    NSArray *cityList = [[response.content objectForKey:@"data"] objectForKey:@"cityList"];
    for (NSString *alphabet in cityList) {
        
        CityModel *cityModel = [self cityModelWithAlphabetTitle:[alphabet uppercaseString]];
        cityModel.cityArray  = [cityList valueForKey:alphabet];
        
    }
    [self.tableView reloadData];
    
}

- (CityModel *)cityModelWithAlphabetTitle:(NSString *)alphabet
{
    
    for (CityModel *cityModal in self.cityData) {
        if ([cityModal.title isEqualToString:alphabet]) {
            return cityModal;
        }
    }
    return nil;
    
}



#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CityModel *cityModel = [self.cityData objectAtIndex:section];
    CGFloat height = [cityModel.cityArray count] ? 30 : 0;
    if (section == 0) {
        height = 35 ;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    CityModel *cityModel = [self.cityData objectAtIndex:section];
    
    return [cityModel.cityArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.cityData.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    CityModel *cityModel = [self.cityData objectAtIndex:section];
    return [cityModel.cityArray count] ? cityModel.title : nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat height       = section ? 30:35;
    UIView *view         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, height)];
    UILabel *label       = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 320, height)];
    CityModel *cityModel = [self.cityData objectAtIndex:section];
    label.text           = cityModel.title;
    label.font           = [UIFont systemFontOfSize:14];
    label.textColor      = [UIColor brokerLightGrayColor];
    [view addSubview:label];
    
    return view;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.indexArray;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier  = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        if (indexPath.section == 0 && !self.isLocatedSuccess) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    CityModel *city     = [self.cityData objectAtIndex:indexPath.section];
    cell.textLabel.text = [[city.cityArray objectAtIndex:indexPath.row] objectForKey:@"cityName"];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityModel *city = [self.cityData objectAtIndex:indexPath.section];
    if (indexPath.section == 0 && !self.isLocatedSuccess) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectCity:)]) {
       [self.delegate didSelectCity:[city.cityArray objectAtIndex:indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doBack:(id)sender {
    
//    if ([self.delegate respondsToSelector:@selector(canceledCitySelection)]) {
//        [self.delegate canceledCitySelection];
//    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
