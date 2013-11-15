//
//  AnjukeEditableTV_DataSource.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-28.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukeEditableTV_DataSource.h"
#import "AnjukeEditableCell.h"
#import "InputOrderManager.h"

@implementation AnjukeEditableTV_DataSource
@synthesize cellArray;
@synthesize superViewController;

- (id)init {
    self = [super init];
    if (self) {
        self.cellArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)createCells:(NSArray *)dataArray isHaozu:(BOOL)isHaozu {
    AnjukeNormalCell *cell = [[AnjukeNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell configureCell:[dataArray objectAtIndex:0]];
    [self.cellArray addObject:cell];
    
    if (isHaozu) { //租房
        for (int i = 1; i < dataArray.count; i ++) {
            AnjukeEditableCell *cell = [[AnjukeEditableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.editDelegate = self.superViewController;
            [cell configureCell:[dataArray objectAtIndex:i]];
            //调整键盘type
            if (i == HZ_T_AREA || i == HZ_T_PRICE) {
                cell.text_Field.keyboardType = UIKeyboardTypeNumberPad;
                if (i == HZ_T_AREA) {
                    cell.unitLb.text = @"平米";
                }
                else if (i == HZ_T_PRICE) {
                    cell.unitLb.text = @"元/月";
                }
            }
            [self.cellArray addObject:cell];
        }
    }
    else { //二手房
        for (int i = 1; i < dataArray.count; i ++) {
            AnjukeEditableCell *cell = [[AnjukeEditableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.editDelegate = self.superViewController;
            [cell configureCell:[dataArray objectAtIndex:i]];
            //调整键盘type
            if (i == AJK_T_AREA || i == AJK_T_PRICE) {
                cell.text_Field.keyboardType = UIKeyboardTypeNumberPad;
                if (i == AJK_T_AREA) {
                    cell.unitLb.text = @"平米";
                }
                else if (i == AJK_T_PRICE) {
                    cell.unitLb.text = @"万元";
                }
            }
            [self.cellArray addObject:cell];
        }
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //在reloadData过程中，numberOfSectionsInTableView和numberOfRowsInSection执行完后，异步执行的cellForRowAtIndexPath可能在下一次reload循环中再被调用
    
    RTListCell *cell = [self.cellArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}


@end
