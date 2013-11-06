//
//  BidPropertyDetailController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseBidPropertyController.h"
#import "BasePropertyObject.h"

@interface BidPropertyDetailController : BaseBidPropertyController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{

}
@property (strong, nonatomic) UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *myArray;
@property (strong, nonatomic) BasePropertyObject *propertyObject;
@end
