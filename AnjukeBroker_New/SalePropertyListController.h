//
//  SalePropertyListController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BasePropertyListController.h"

@interface SalePropertyListController : BasePropertyListController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *myTable;
    NSMutableArray *myArray;
}
@end
