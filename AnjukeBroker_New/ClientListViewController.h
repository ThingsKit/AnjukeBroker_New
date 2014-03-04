//
//  ClientListViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-2-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "ClientListCell.h"

@interface ClientListViewController : RTViewController <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

@property BOOL isForMessageList; //是否是消息列表+号调用，是则修改tableView frame和点击事件

@end
