//
//  BidPropertyDetailController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseBidPropertyController.h"
#import "PropertyObject.h"

@interface BidPropertyDetailController : BaseBidPropertyController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    UITableView *myTable;
    NSMutableArray *myArray;
}
@property (strong, nonatomic) PropertyObject *propertyObject;
@end
