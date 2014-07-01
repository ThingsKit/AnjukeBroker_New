//
//  BrokerRegisterWorkPlateViewController.m
//  AnjukeBroker_New
//
//  Created by jason on 6/25/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "BrokerRegisterWorkBlockViewController.h"
#import "BrokerRegisterInfoViewController.h"
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
    NSDictionary *params = @{@"districtId":[district objectForKey:@"districtId"],@"is_nocheck":@"1"};
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
<<<<<<< HEAD
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    RTLineView *lineView = [[RTLineView alloc] initWithFrame:CGRectMake(15, 44, 305, 1)];
    if (indexPath.row == (self.dataArray.count - 1 )) {
        lineView.frame = CGRectMake(0, 44, 320, 1);
    }
    [cell addSubview:lineView];
=======
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        RTLineView *lineView = [[RTLineView alloc] initWithFrame:CGRectMake(15, 44, 305, 1)];
        [cell addSubview:lineView];
    }
>>>>>>> add register model
    
    cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"blockName"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = @{@"district":self.district,@"block":[self.dataArray objectAtIndex:indexPath.row]};
    BrokerRegisterInfoViewController *viewController = [self.navigationController.viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:viewController animated:YES];
<<<<<<< HEAD
    if ([self.delegate respondsToSelector:@selector(didSelectWorkRange:)]) {
        [self.delegate didSelectWorkRange:dic];
    }
=======
    [self.delegate didSelectWorkRange:dic];
>>>>>>> add register model
    
}

@end
