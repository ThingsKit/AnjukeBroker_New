//
//  FangYuanTableView.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PropertyTableView.h"
#import "PropertyTableViewCell.h"

@implementation PropertyTableView

#pragma mark -
#pragma mark - Table view data source

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
    }
    
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"PropertyTableViewCell";
    PropertyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PropertyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    PropertyModel* property = (PropertyModel*)[self.data objectAtIndex:indexPath.row]; //获取self.data中的数据对象
    cell.propertyModel = property;
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell不可选中
    
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
