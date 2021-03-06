//
//  PublishTableViewDataSource.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-19.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
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
@synthesize isSafeNum = _isSafeNum;

- (void)createCells:(NSArray *)dataArray isHaozu:(BOOL)isHaozu {
    [self initModel];
    
    DLog(@"dataArray == %@", dataArray);
    
    if (isHaozu) { //租房
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

        UIViewController *controller = (UIViewController *)self.superViewController ;
        
        CGFloat vwidth = CGRectGetWidth(controller.view.frame);
        AnjukeNormalCell *v = [[AnjukeNormalCell alloc] initWithFrame:CGRectMake(0, 0, vwidth, 20)];
        [v removeAllSubView];
        [v setBackgroundColor:[UIColor clearColor]];
        [section1 addObject:v];
        
        //******房型、楼层、装修、出租方式
//        NSMutableArray *section2 = [NSMutableArray array];
        //rooms 户型
        AnjukeEditableCell *cell3 = [[AnjukeEditableCell alloc] init];
        cell3.editDelegate = self.superViewController;
        if ([cell3 configureCell:[dataArray objectAtIndex:HZ_PICKER_ROOMS]]) {
            [cell3 setIndexTag:HZ_PICKER_ROOMS];
            [section1 addObject:cell3];
            [self.inputCellArray addObject:cell3];
            
            [cell3 showTopLine]; //top line
        }
        //floors 楼层
        AnjukeEditableCell *cell4 = [[AnjukeEditableCell alloc] init];
        cell4.editDelegate = self.superViewController;
        if ([cell4 configureCell:[dataArray objectAtIndex:HZ_PICKER_FLOORS]]) {
            [cell4 setIndexTag:HZ_PICKER_FLOORS];
            [section1 addObject:cell4];
            [self.inputCellArray addObject:cell4];
        }
        //floors 楼层
        AnjukeEditableCell *cell41 = [[AnjukeEditableCell alloc] init];
        cell41.editDelegate = self.superViewController;
        if ([cell41 configureCell:[dataArray objectAtIndex:HZ_PICKER_ORIENTATION]]) {
            [cell41 setIndexTag:HZ_PICKER_ORIENTATION];
            [section1 addObject:cell41];
            [self.inputCellArray addObject:cell41];
        }
        //fitment 装修
        AnjukeEditableCell *cell5 = [[AnjukeEditableCell alloc] init];
        cell5.editDelegate = self.superViewController;
        if ([cell5 configureCell:[dataArray objectAtIndex:HZ_PICKER_FITMENT]]) {
            [cell5 setIndexTag:HZ_PICKER_FITMENT];
            [section1 addObject:cell5];
            [self.inputCellArray addObject:cell5];
        }
        //rent type 出租方式
        AnjukeEditableCell *cell21 = [[AnjukeEditableCell alloc] init];
        cell21.editDelegate = self.superViewController;
        if ([cell21 configureCell:[dataArray objectAtIndex:HZ_PICKER_RENTTYPE]]) {
            [cell21 setIndexTag:HZ_PICKER_RENTTYPE];
            [section1 addObject:cell21];
            [self.inputCellArray addObject:cell21];
        }

        [section1 addObject:v];
        
        //******标题、描述
//        NSMutableArray *section3 = [NSMutableArray array];
        //title \ desc
        AnjukeNormalCell *cell6 = [[AnjukeNormalCell alloc] init];
        if ([cell6 configureCell:[dataArray objectAtIndex:HZ_CLICK_TITLE]]) {
            [cell6 setIndexTag:HZ_CLICK_TITLE];
            [section1 addObject:cell6];
            [self.inputCellArray addObject:cell6];
            
            [cell6 showTopLine]; //top line
        }
        AnjukeNormalCell *cell7 = [[AnjukeNormalCell alloc] init];
        if ([cell7 configureCell:[dataArray objectAtIndex:HZ_CLICK_DESC]]) {
            [cell7 setIndexTag:HZ_CLICK_DESC];
            [section1 addObject:cell7];
            [self.inputCellArray addObject:cell7];
        }
        [self.cellArray addObject:section1];
    }
    else { //二手房
        //******价格、最低首付、产证面积
        NSMutableArray *section1 = [NSMutableArray array];
        //price
        AnjukeEditableCell *cell = [[AnjukeEditableCell alloc] init];
        cell.editDelegate = self.superViewController;
        if ([cell configureCell:[dataArray objectAtIndex:AJK_TEXT_PRICE]]) {
            [cell setIndexTag:AJK_TEXT_PRICE];
            [[cell unitLb] setText:@"万元"];
            [section1 addObject:cell];
            [self.inputCellArray addObject:cell];
            
            [cell showTopLine]; //top line
        }
        
        //area
        AnjukeEditableCell *cell2 = [[AnjukeEditableCell alloc] init];
        cell2.editDelegate = self.superViewController;
        if ([cell2 configureCell:[dataArray objectAtIndex:AJK_TEXT_AREA]]) {
            [cell2 setIndexTag:AJK_TEXT_AREA];
            [[cell2 unitLb] setText:@"平米"];
            [section1 addObject:cell2];
            [self.inputCellArray addObject:cell2];
            
        }
        
        if (_isSafeNum)
        {//备案号
            //area
            AnjukeEditableCell *cell21 = [[AnjukeEditableCell alloc] init];
            cell21.editDelegate = self.superViewController;
            if ([cell21 configureCell:[dataArray objectAtIndex:AJK_TEXT_SAFENUM]]) {
                [cell21 setIndexTag:AJK_TEXT_SAFENUM];
                [section1 addObject:cell21];
                [self.inputCellArray addObject:cell21];
            }
        }
//        [self.cellArray addObject:section1];
        
        UIViewController *controller = (UIViewController *)self.superViewController ;
        
        CGFloat vwidth = CGRectGetWidth(controller.view.frame);
        AnjukeNormalCell *v = [[AnjukeNormalCell alloc] initWithFrame:CGRectMake(0, 0, vwidth, 20)];
        [v removeAllSubView];
        [v setBackgroundColor:[UIColor clearColor]];
        [section1 addObject:v];
        
        
        //******房型、楼层、装修、特色
//        NSMutableArray *section2 = [NSMutableArray array];
        //rooms 房型
        AnjukeEditableCell *cell3 = [[AnjukeEditableCell alloc] init];
        cell3.editDelegate = self.superViewController;
        if ([cell3 configureCell:[dataArray objectAtIndex:AJK_PICKER_ROOMS]]) {
            [cell3 setIndexTag:AJK_PICKER_ROOMS];
            [section1 addObject:cell3];
            [self.inputCellArray addObject:cell3];
            
            [cell3 showTopLine]; //top line
        }
        //floors 楼层
        AnjukeEditableCell *cell4 = [[AnjukeEditableCell alloc] init];
        cell4.editDelegate = self.superViewController;
        if ([cell4 configureCell:[dataArray objectAtIndex:AJK_PICKER_FLOORS]]) {
            [cell4 setIndexTag:AJK_PICKER_FLOORS];
            [section1 addObject:cell4];
            [self.inputCellArray addObject:cell4];
        }
        
        //朝向 orientation
        AnjukeEditableCell *cell41 = [[AnjukeEditableCell alloc] init];
        cell41.editDelegate = self.superViewController;
        if ([cell41 configureCell:[dataArray objectAtIndex:AJK_PICKER_ORIENTATION]]) {
            [cell41 setIndexTag:AJK_PICKER_ORIENTATION];
            [section1 addObject:cell41];
            [self.inputCellArray addObject:cell41];
        }
        
        
        //fitment
        AnjukeEditableCell *cell5 = [[AnjukeEditableCell alloc] init];
        cell5.editDelegate = self.superViewController;
        if ([cell5 configureCell:[dataArray objectAtIndex:AJK_PICKER_FITMENT]]) {
            [cell5 setIndexTag:AJK_PICKER_FITMENT];
            [section1 addObject:cell5];
            [self.inputCellArray addObject:cell5];
        }
        
        //feature
        AnjukeNormalCell *cell55 = [[AnjukeNormalCell alloc] init];
        if ([cell55 configureCell:[dataArray objectAtIndex:AJK_CLICK_FEATURE]]) {
            [cell55 setIndexTag:AJK_CLICK_FEATURE];
            [cell55 setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell55 drawSpecView];
            [section1 addObject:cell55];
            [self.inputCellArray addObject:cell55];
            
        }
        [section1 addObject:v];
//        [self.cellArray addObject:section2];
        
        //******标题、描述
//        NSMutableArray *section3 = [NSMutableArray array];
        //title \ desc
        AnjukeNormalCell *cell6 = [[AnjukeNormalCell alloc] init];
        if ([cell6 configureCell:[dataArray objectAtIndex:AJK_CLICK_TITLE]]) {
            [cell6 setIndexTag:AJK_CLICK_TITLE];
            [section1 addObject:cell6];
            [self.inputCellArray addObject:cell6];
            
            [cell6 showTopLine]; //top line
        }
        AnjukeNormalCell *cell7 = [[AnjukeNormalCell alloc] init];
        if ([cell7 configureCell:[dataArray objectAtIndex:AJK_CLICK_DESC]]) {
            [cell7 setIndexTag:AJK_CLICK_DESC];
            [section1 addObject:cell7];
            [self.inputCellArray addObject:cell7];
        }
        
        [self.cellArray addObject:section1];
    }
    
    //将inputCellArray中的输入框cell放入inputJumpCellArray中
    for (int i = 0; i < self.inputCellArray.count; i ++) {
        if ([[self.inputCellArray objectAtIndex:i] isKindOfClass:[AnjukeNormalCell class]]) {
            [self.indexJumpCellArray addObject:[self.inputCellArray objectAtIndex:i]];
        }
    }
}

- (void)houseTypeCellImageIconShow:(BOOL)show isHaozu:(BOOL)isHaozu {
    return;
    int houseTypeIndex = 0;
    if (isHaozu) {
        houseTypeIndex = HZ_PICKER_ROOMS;
    }
    else
        houseTypeIndex = AJK_PICKER_ROOMS;
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    DLog(@"self.cellArray == %@", self.cellArray);
    int count = 0;
    for (int i = 0; i < self.cellArray.count; i++)
    {
        count += [[self.cellArray objectAtIndex:i] count];
    }
    DLog(@"count == %d", count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //在reloadData过程中，numberOfSectionsInTableView和numberOfRowsInSection执行完后，异步执行的cellForRowAtIndexPath可能在下一次reload循环中再被调用
//    if (indexPath.section >= self.cellArray.count || indexPath.row >= [[self.cellArray objectAtIndex:indexPath.section] count])
//        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    DLog(@"indexPath.section == %d", indexPath.section);
    DLog(@"indexPath.row == %d", indexPath.row);
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    RTListCell *cell = [[self.cellArray objectAtIndex:section] objectAtIndex:row];
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isSafeNum)
    {
        if (indexPath.row == 2)
        {
            return 20;
        }else if (indexPath.row == 8)
        {
            return 20;
        }
    }else
    {
        if (indexPath.row == 3)
        {
            return 20;
        }else if (indexPath.row == 9)
        {
            return 20;
        }
    }
    
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
