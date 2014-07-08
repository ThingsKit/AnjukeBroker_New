//
//  BrokerRegisterWorkPlateViewController.m
//  AnjukeBroker_New
//
//  Created by jason on 6/25/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "BrokerRegisterWorkBlockViewController.h"
#import "BrokerRegisterInfoViewController.h"
#import "RTListCell.h"
#import <RTLineView.h>


@interface BrokerRegisterWorkBlockViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong)UITableView  *tableView;
@property(nonatomic,strong)NSArray      *dataArray;
@property(nonatomic,strong)NSDictionary *district;

@end

@implementation BrokerRegisterWorkBlockViewController

- (void) loadBlockDataWithDistrict:(NSDictionary *)district
{
    self.district        = district;
    NSString     *method = @"common/blocks/";
    NSDictionary *params = @{@"districtId":[district objectForKey:@"districtId"]};
    [[RTRequestProxy sharedInstance]asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(handleBlockResponseData:)];
 
}

- (void)handleBlockResponseData:(RTNetworkResponse *)response {
    
    if (response.status == RTNetworkResponseStatusFailed) {
       [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    NSDictionary *data = [response.content objectForKey:@"data"];
    self.dataArray = [data objectForKey:@"blockList"];
    [self.tableView reloadData];
    
}

-(void) viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brokerBgPageColor];

    UITableView *tableView    = [[UITableView alloc] initWithFrame:[UIView navigationControllerBound] style:UITableViewStylePlain];
    tableView.delegate        = self;
    tableView.dataSource      = self;
    tableView.rowHeight       = 45;
    tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setTitleViewWithString:@"工作板块"];
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
    
    
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
    textLabel.text       = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"blockName"];
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
    
    NSDictionary *dic = @{@"district":self.district,@"block":[self.dataArray objectAtIndex:indexPath.row]};
    BrokerRegisterInfoViewController *viewController = [self.navigationController.viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:viewController animated:YES];

    if ([self.delegate respondsToSelector:@selector(didSelectWorkRange:)]) {
        [self.delegate didSelectWorkRange:dic];
    }
    
}

@end
