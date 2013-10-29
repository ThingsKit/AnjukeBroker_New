//
//  SalePropertyDetailController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BasePropertyDetailController.h"
#import "PropertyObject.h"
#import "FixedObject.h"

@interface SalePropertyDetailController : BasePropertyDetailController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    UITableView *myTable;
    NSMutableArray *myArray;
}
@property (strong, nonatomic) PropertyObject *propertyObject;
@property (strong, nonatomic) FixedObject *fixedObject;
@end
