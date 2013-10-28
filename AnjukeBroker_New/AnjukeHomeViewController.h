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
    UITableView *myTable;
    NSMutableArray *myArray;

}
@end
