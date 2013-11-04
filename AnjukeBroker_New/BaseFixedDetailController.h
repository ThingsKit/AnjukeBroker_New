//
//  BaseFixedDetailController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@interface BaseFixedDetailController : RTViewController <UITableViewDelegate, UITableViewDataSource>
{
}
@property (strong, nonatomic) UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *myArray;

@end
