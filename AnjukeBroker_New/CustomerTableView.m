//
//  CustomerTableView.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CustomerTableView.h"
#import "CustomerModel.h"
#import "CustomerTableViewCell.h"

@implementation CustomerTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"CustomerTableViewCell";
    CustomerTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    CustomerModel* customer = (CustomerModel*)[self.data objectAtIndex:indexPath.row];
    cell.customerModel = customer;
    
    if (indexPath.row == self.data.count-1) {
        [cell showBottonLineWithCellHeight:84];
    }else{
        [cell showBottonLineWithCellHeight:84 andOffsetX:15];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.data.count > 0) {
        return 40;
    }else{
        return 0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_header == nil) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _header.backgroundColor = [UIColor brokerBgPageColor];
        UILabel* label = [[UILabel alloc] initWithFrame:_header.bounds];
        [_header addSubview:label];
        label.font = [UIFont ajkH4Font];
        label.textColor = [UIColor brokerLightGrayColor];
        label.text = [NSString stringWithFormat:@"%d个客户正在找你熟悉的小区房源 | 可抢人数: %d", 50, 1];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    return _header;
}

#pragma mark -
#pragma mark 解决section不跟随tableView移动的问题
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

@end
