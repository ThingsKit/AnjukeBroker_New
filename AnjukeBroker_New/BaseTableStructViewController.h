//
//  BaseTableStructViewController.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-14.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "BrokerTableStuct.h"
#import "EGORefreshTableHeaderView.h"
#import "BrokerTableStuct.h"

@interface BaseTableStructViewController : RTViewController<EGORefreshTableHeaderDelegate,UITableViewDelegate>
@property(nonatomic, strong) BrokerTableStuct *tableList;

- (void)autoPullDown;
- (void)donePullDown;
- (void)doRequest;
@end
