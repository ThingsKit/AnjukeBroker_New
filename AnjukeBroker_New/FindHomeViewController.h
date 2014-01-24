//
//  FindHomeViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-24.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@interface FindHomeViewController : RTViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *myArray;
@end
