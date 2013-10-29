//
//  SaleBidDetailController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseBidDetailController.h"

@interface SaleBidDetailController : BaseBidDetailController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *myTablel;
    NSMutableArray *myArray;

}
@end
