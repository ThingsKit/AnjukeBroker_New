//
//  AnjukeEditableTV_DataSource.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-28.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnjukeEditPropertyViewController.h"
#import "AnjukeNormalCell.h"

@interface AnjukeEditableTV_DataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) AnjukeEditPropertyViewController *superViewController;

- (void)createCells:(NSArray *)dataArray;

@end
