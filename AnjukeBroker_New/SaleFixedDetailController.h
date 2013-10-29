//
//  SaleFixedDetailController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseFixedDetailController.h"

@interface SaleFixedDetailController : BaseFixedDetailController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    UITableView *myTable;
    NSMutableArray *myArray;
    NSString *fixedStatus;
}
@end
