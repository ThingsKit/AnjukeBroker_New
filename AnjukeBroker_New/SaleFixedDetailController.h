//
//  SaleFixedDetailController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseFixedDetailController.h"
#import "RTPopoverTableViewController.h"

@interface SaleFixedDetailController : BaseFixedDetailController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, RTPopoverTableViewDelegate, UIPopoverControllerDelegate>
{
    UITableView *myTable;
    NSMutableArray *myArray;
    
}
@property (strong, nonatomic) UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *myArray;

@end
