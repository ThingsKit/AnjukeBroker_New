//
//  BaseTableStructViewController.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-14.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTViewController.h"
#import "BrokerTableStuct.h"
#import "BK_EGORefreshTableHeaderView.h"
#import "BrokerTableStuct.h"


@interface BaseTableStructViewController : RTViewController<EGORefreshTableHeaderDelegate,UITableViewDelegate>

@property(nonatomic, assign) BOOL forbiddenEgo;
@property(nonatomic, strong) BrokerTableStuct *tableList;
@property (nonatomic, strong) BK_EGORefreshTableHeaderView* refreshHeaderView; //下拉刷新表头

- (void)autoPullDown;
- (void)donePullDown;
- (void)doRequest;
@end
