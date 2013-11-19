//
//  NoPlanController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/28/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "Util_UI.h"
#define SELECT_ALL_STR @"全选"
#define UNSELECT_ALL_STR @"取消全选"

#define TOOL_BAR_HEIGHT 44

@interface BaseNoPlanController : RTViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}
@property (strong, nonatomic) UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *myArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (strong, nonatomic) UIImageView *iamge;

@end
