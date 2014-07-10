//
//  houseSelectViewController.h
//  AnjukeBroker_New
//
//  Created by shan xu on 14-2-26.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTViewController.h"
#import "HouseSelectCommunityCell.h"
#import "PropertyDetailCell.h"
#import "CellHeight.h"
#import "AppManager.h"
#import "LoginManager.h"

@interface HouseSelectViewController : RTViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableList;

@end
