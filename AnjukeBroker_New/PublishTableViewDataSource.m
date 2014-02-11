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
@synthesize inputCellArray;
@synthesize indexJumpCellArray;

- (void)createCells:(NSArray *)dataArray isHaozu:(BOOL)isHaozu {
    [self initModel];
    
    if (isHaozu) {
        //******价格、产证面积、出租方式
        NSMutableArray *section1 = [NSMutableArray array];
        //price
        AnjukeEditableCell *cell = [[AnjukeEditableCell alloc] init];
        cell.editDelegate = self.superViewController;
        if ([cell configureCell:[dataArray objectAtIndex:HZ_TEXT_PRICE]]) {
            [cell setIndexTag:HZ_TEXT_PRICE];
            [[cell unitLb] setText:@"元/月"];
            [section1 addObject:cell];
            [self.inputCellArray addObject:cell];
            
            [cell showTopLine]; //top line
        }
        //area
        AnjukeEditableCell *cell2 = [[AnjukeEditableCell alloc] init];
        cell2.editDelegate = self.superViewController;
        if ([cell2 configureCell:[dataArray objectAtIndex:HZ_TEXT_AREA]]) {
            [cell2 setIndexTag:HZ_TEXT_AREA];
            [[cell2 unitLb] setText:@"平米"];
            [section1 addObject:cell2];
            [self.inputCellArray addObject:cell2];
        }
        [self.cellArray addObject:section1];
        
        //******房型、楼层、装修、出租方式
        NSMutableArray *section2 = [NSMutableArray array];
        //rooms 房型
        AnjukeNormalCell *cell3 = [[AnjukeNormalCell alloc] init];
        if ([cell3 configureCell:[dataArray objectAtIndex:HZ_CLICK_ROOMS]]) {
            [cell3 setIndexTag:HZ_CLICK_ROOMS];
            [section2 addObject:cell3];
            [self.inputCellArray addObject:cell3];
            
            [cell3 showTopLine]; //top line
        }
        //floors 楼层
        AnjukeEditableCell *cell4 = [[AnjukeEditableCell alloc] init];
        cell4.editDelegate = self.superViewController;
        if ([cell4 configureCell:[dataArray objectAtIndex:HZ_PICKER_FLOORS]]) {
            [cell4 setIndexTag:HZ_PICKER_FLOORS];
            [section2 addObject:cell4];
            [self.inputCellArray addObject:cell4];
        }
        //fitment 装修
        AnjukeEditableCell *cell5 = [[AnjukeEditableCell alloc] init];
        cell5.editDelegate = self.superViewController;
        if ([cell5 configureCell:[dataArray objectAtIndex:HZ_PICKER_FITMENT]]) {
            [cell5 setIndexTag:HZ_PICKER_FITMENT];
            [section2 addObject:cell5];
            [self.inputCellArray addObject:cell5];
        }
        //rent type 出租方式
        AnjukeEditableCell *cell21 = [[AnjukeEditableCell alloc] init];
        cell21.editDelegate = self.superViewController;
        if ([cell21 configureCell:[dataArray objectAtIndex:HZ_PICKER_RENTTYPE]]) {
            [cell21 setIndexTag:HZ_PICKER_RENTTYPE];
            [section2 addObject:cell21];
            [self.inputCellArray addObject:cell21];
        }
        [self.cellArray addObject:section2];
        
        //******标题、描述
        NSMutableArray *section3 = [NSMutableArray array];
        //title \ desc
        AnjukeNormalCell *cell6 = [[AnjukeNormalCell alloc] init];
        if ([cell6 configureCell:[dataArray objectAtIndex:HZ_CLICK_TITLE]]) {
            [cell6 setIndexTag:HZ_CLICK_TITLE];
            [section3 addObject:cell6];
            [self.inputCellArray addObject:cell6];
            
            [cell6 showTopLine]; //top line
        }
        AnjukeNormalCell *cell7 = [[AnjukeNormalCell alloc] init];
        if ([cell7 configureCell:[dataArray objectAtIndex:HZ_CLICK_DESC]]) {
            [cell7 setIndexTag:HZ_CLICK_DESC];
            [section3 addObject:cell7];
            [self.inputCellArray addObject:cell7];
        }
        [self.cellArray addObject:section3];
    }
    else {
        //******价格、产证面积
        NSMutableArray *section1 = [NSMutableArray array];
        //price
        AnjukeEditableCell *cell = [[AnjukeEditableCell alloc] init];
        cell.editDelegate = self.superViewController;
        if ([cell configureCell:[dataArray objectAtIndex:HZ_TEXT_PRICE]]) {
            [cell setIndexTag:HZ_TEXT_PRICE];
            [[cell unitLb] setText:@"万元"];
            [section1 addObject:cell];
            [self.inputCellArray addObject:cell];
            
            [cell showTopLine]; //top line
        }
        //area
        AnjukeEditableCell *cell2 = [[AnjukeEditableCell alloc] init];
        cell2.editDelegate = self.superViewController;
        if ([cell2 configureCell:[dataArray objectAtIndex:HZ_TEXT_AREA]]) {
            [cell2 setIndexTag:HZ_TEXT_AREA];
            [[cell2 unitLb] setText:@"平米"];
            [section1 addObject:cell2];
            [self.inputCellArray addObject:cell2];
        }
        [self.cellArray addObject:section1];
        
        //******房型、楼层、装修
        NSMutableArray *section2 = [NSMutableArray array];
        //rooms 房型
        AnjukeNormalCell *cell3 = [[AnjukeNormalCell alloc] init];
        if ([cell3 configureCell:[dataArray objectAtIndex:AJK_CLICK_ROOMS]]) {
            [cell3 setIndexTag:AJK_CLICK_ROOMS];
            [section2 addObject:cell3];
            [self.inputCellArray addObject:cell3];
            
            [cell3 showTopLine]; //top line
        }
        //floors 楼层
        AnjukeEditableCell *cell4 = [[AnjukeEditableCell alloc] init];
        cell4.editDelegate = self.superViewController;
        if ([cell4 configureCell:[dataArray objectAtIndex:AJK_PICKER_FLOORS]]) {
            [cell4 setIndexTag:AJK_PICKER_FLOORS];
            [section2 addObject:cell4];
            [self.inputCellArray addObject:cell4];
        }
        //fitment
        AnjukeEditableCell *cell5 = [[AnjukeEditableCell alloc] init];
        cell5.editDelegate = self.superViewController;
        if ([cell5 configureCell:[dataArray objectAtIndex:AJK_PICKER_FITMENT]]) {
            [cell5 setIndexTag:AJK_PICKER_FITMENT];
            [section2 addObject:cell5];
            [self.inputCellArray addObject:cell5];
        }
        [self.cellArray addObject:section2];
        
        //******标题、描述
        NSMutableArray *section3 = [NSMutableArray array];
        //title \ desc
        AnjukeNormalCell *cell6 = [[AnjukeNormalCell alloc] init];
        if ([cell6 configureCell:[dataArray objectAtIndex:AJK_CLICK_TITLE]]) {
            [cell6 setIndexTag:AJK_CLICK_TITLE];
            [section3 addObject:cell6];
            [self.inputCellArray addObject:cell6];
            
            [cell6 showTopLine]; //top line
        }
        AnjukeNormalCell *cell7 = [[AnjukeNormalCell alloc] init];
        if ([cell7 configureCell:[dataArray objectAtIndex:AJK_CLICK_DESC]]) {
            [cell7 setIndexTag:AJK_CLICK_DESC];
            [section3 addObject:cell7];
            [self.inputCellArray addObject:cell7];
        }
        [self.cellArray addObject:section3];
    }
    
    //将inputCellArray中的输入框cell放入inputJumpCellArray中
    for (int i = 0; i < self.inputCellArray.count; i ++) {
        if ([[self.inputCellArray objectAtIndex:i] isKindOfClass:[AnjukeNormalCell class]]) {
            [self.indexJumpCellArray addObject:[self.inputCellArray objectAtIndex:i]];
        }
    }
}

- (void)houseTypeCellImageIconShow:(BOOL)show isHaozu:(BOOL)isHaozu {
    int houseTypeIndex = 0;
    if (isHaozu) {
        houseTypeIndex = HZ_CLICK_ROOMS;
    }
    else
        houseTypeIndex = AJK_CLICK_ROOMS;
    
    UIImage *icon = [UIImage imageNamed:@"anjuke_icon_fxt_mini_.png"];
    if (show) {
        [[(AnjukeNormalCell *)[self.inputCellArray objectAtIndex:houseTypeIndex] iconImage] setImage:icon];
    }
    else
        [[(AnjukeNormalCell *)[self.inputCellArray objectAtIndex:houseTypeIndex] iconImage] setImage:nil];
}

- (void)initModel {
    self.cellArray = [NSMutableArray array];
    self.inputCellArray = [NSMutableArray array];
    self.indexJumpCellArray = [NSMutableArray array];
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

#pragma mark - UITableView Delegate

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    return 0;//PUBLISH_SECTION_HEIGHT;
}

- (CGFloat)heightForFooterInSection:(NSInteger)section {
    if (section >= 2) {
        return 0;
    }
    return PUBLISH_SECTION_HEIGHT;
}

- (UIView *)viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, PUBLISH_SECTION_HEIGHT)];
    headerView.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    
    return headerView;
}

@end
