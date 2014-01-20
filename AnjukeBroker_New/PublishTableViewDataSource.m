//
//  PublishTableViewDataSource.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-19.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishTableViewDataSource.h"
#import "AnjukeEditableCell.h"
#import "AnjukeNormalCell.h"
#import "PublishBuildingViewController.h"
#import "PublishInputOrderModel.h"

@implementation PublishTableViewDataSource
@synthesize cellArray, superViewController;

- (void)createCells:(NSArray *)dataArray isHaozu:(BOOL)isHaozu {
    //价格、产证面积、出租方式
    NSMutableArray *section1 = [NSMutableArray array];
    AnjukeEditableCell *cell = [[AnjukeEditableCell alloc] init];
    if ([cell configureCell:@"价格"]) {
        [cell setIndexTag:AJK_TEXT_PRICE];
        
        [section1 addObject:cell];
    }
    
    
    
    
    [self.cellArray addObject:section1];
    
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.cellArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //在reloadData过程中，numberOfSectionsInTableView和numberOfRowsInSection执行完后，异步执行的cellForRowAtIndexPath可能在下一次reload循环中再被调用
    if (indexPath.section >= self.cellArray.count || indexPath.row >= [[self.cellArray objectAtIndex:indexPath.section] count])
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    RTListCell *cell = [[self.cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    headerView.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    
    return headerView;
}

@end
