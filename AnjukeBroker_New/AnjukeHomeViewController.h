//
//  AJK_AnjukeHomeViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@interface AnjukeHomeViewController : RTViewController <UITableViewDataSource, UITableViewDelegate>
{


}
@property (strong, nonatomic) UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *myArray;
@property (strong, nonatomic) NSString *isSeedPid;//当只有一个定价组时，把planId带到定价过程

@end
