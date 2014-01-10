//
//  BaseFixedDetailController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "FixedObject.h"
#import "EGORefreshTableHeaderView.h"

@interface BaseFixedDetailController : RTViewController <UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate>
{
}
@property (strong, nonatomic) UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *myArray;
@property (nonatomic, strong) FixedObject *planDic;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshView;

-(void)doRequest;
-(void)reloadData;

@end
