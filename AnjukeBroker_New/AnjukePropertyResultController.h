//
//  AnjukeUploadPropertyResultController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/21/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

typedef enum {
    PropertyResultOfRentNoPlan = 0,
    PropertyResultOfRentFixed,
    PropertyResultOfRentBid,
    PropertyResultOfSaleNoPlan,
    PropertyResultOfSaleFixed,
    PropertyResultOfSaleBid
} PropertyResultType;

@interface AnjukePropertyResultController : RTViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *myArray;
@property PropertyResultType resultType;
@property (strong, nonatomic) NSString *planId;
@end
