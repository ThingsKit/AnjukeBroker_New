//
//  FindHomeViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-24.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTViewController.h"
#import "BK_EGORefreshTableHeaderView.h"

@interface FindHomeViewController : RTViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>
@property (strong, nonatomic) UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *myArray;
@property (nonatomic, strong) BK_EGORefreshTableHeaderView *refreshView;
@end
