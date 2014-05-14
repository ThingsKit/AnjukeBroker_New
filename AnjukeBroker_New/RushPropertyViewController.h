//
//  QiangFangYuanWeiTuoViewController.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "PropertyTableView.h"
#import "MyPropertyTableView.h"

@interface RushPropertyViewController : RTViewController<BaseTableViewEventDelegate>

- (void)autoRefresh; //自动拉下刷新

@end
