//
//  BaseBidDetailController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "BK_EGORefreshTableHeaderView.h"

@interface BaseBidDetailController : RTViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, EGORefreshTableHeaderDelegate>

@property (strong, nonatomic) UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *myArray;
@property (nonatomic, strong) BK_EGORefreshTableHeaderView *refreshView;

-(void)doRequest;
-(void)reloadData;

@end
