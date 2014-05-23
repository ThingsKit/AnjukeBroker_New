//
//  MyPropertyTableView.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-14.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "MyPropertyTableView.h"
#import "MyPropertyTableViewCell.h"
#import "MyPropertyModel.h"

@implementation MyPropertyTableView

#pragma mark -
#pragma mark - Table view data source

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
    }
    
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"MyPropertyTableViewCell";
    MyPropertyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyPropertyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MyPropertyModel* property = [self.data objectAtIndex:indexPath.row]; //获取self.data中的数据对象
    cell.myPropertyModel = property;
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //默认无法选中
    if (indexPath.row == self.data.count-1) {
        [cell showBottonLineWithCellHeight:85];
    }else{
        [cell showBottonLineWithCellHeight:85 andOffsetX:15];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

@end
