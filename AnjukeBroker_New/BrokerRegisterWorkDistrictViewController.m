//
//  BrokerRegisterWorkAreaViewController.m
//  AnjukeBroker_New
//
//  Created by jason on 6/25/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "BrokerRegisterWorkDistrictViewController.h"
#import "RTListCell.h"
#import <RTLineView.h>
#import "UIView+RTLayout.h"

@interface BrokerRegisterWorkDistrictViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong)UITableView  *tableView;
@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation BrokerRegisterWorkDistrictViewController


- (void)loadDistrictDataWithCityId:(NSString *)cityId
{
    if (cityId == nil || [cityId isEqualToString:@""]) {
        return;
        
    }

    NSString     *method = @"common/districts/";
    NSDictionary *params  = @{@"cityId":cityId};
    [[RTRequestProxy sharedInstance]asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(handleAreaData:)];
    
}

- (void) handleAreaData:(RTNetworkResponse *)response {
    
    if (response.status == RTNetworkResponseStatusFailed) {
       [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    NSDictionary *data = [response.content objectForKey:@"data"];
    self.dataArray = [data objectForKey:@"districtList"];
    [self.tableView reloadData];
    
}

-(void) viewDidLoad {
    
    [super viewDidLoad];
    UITableView *tableView    = [[UITableView alloc] initWithFrame:[UIView navigationControllerBound] style:UITableViewStylePlain];
    tableView.delegate        = self;
    tableView.dataSource      = self;
    tableView.rowHeight       = 45;
    tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor brokerBgPageColor];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setTitleViewWithString:@"工作区域"];
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *identifier = @"identifier";
    RTListCell *cell     = [[RTListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.accessoryType   = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle  = UITableViewCellSelectionStyleGray;
    UILabel *textLabel   = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 320, 45)];
    textLabel.textColor  = [UIColor darkGrayColor];
    textLabel.font       = [UIFont ajkH2Font];
    textLabel.text       = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"districtName"];
    cell.contentView.backgroundColor   = [UIColor whiteColor];
    [cell.contentView addSubview:textLabel];
    if (indexPath.row == 0) {
        [cell showTopLine];
        [cell showBottonLineWithCellHeight:45 andOffsetX:15];
    } else if (indexPath.row == ([self.dataArray count] - 1)) {
        [cell showBottonLineWithCellHeight:45];
    } else {
        [cell showBottonLineWithCellHeight:45 andOffsetX:15];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    BrokerRegisterWorkBlockViewController *workBlockViewController = [[BrokerRegisterWorkBlockViewController alloc] init];
    [workBlockViewController loadBlockDataWithDistrict:[self.dataArray objectAtIndex:indexPath.row]];
    workBlockViewController.delegate = self.delegate;
    [self.navigationController pushViewController:workBlockViewController animated:YES];
    
}


@end
