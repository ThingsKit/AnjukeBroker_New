//
//  NoPlanController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/28/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@interface NoPlanController : RTViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *myTable;
    NSMutableArray *myArray;
    NSMutableArray *selected;
}
@end
