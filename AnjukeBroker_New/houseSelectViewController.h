//
//  houseSelectViewController.h
//  AnjukeBroker_New
//
//  Created by shan xu on 14-2-26.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "houseSelectCommunityCell.h"
#import "PropertyDetailCell.h"
#import "CellHeight.h"
#import "AppManager.h"
#import "LoginManager.h"

@interface houseSelectViewController : RTViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableList;

@end
