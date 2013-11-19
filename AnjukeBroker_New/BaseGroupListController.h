//
//  SaleGroupListController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/12/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@interface BaseGroupListController : RTViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *myArray;
@property (strong, nonatomic) NSMutableArray *propertyArray;
@end
