//
//  CustomerTableView.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "CustomerTableView.h"
#import "CustomerModel.h"
#import "CustomerTableViewCell.h"
#import "CustomerHeaderView.h"
#import "CustomerListModel.h"

@interface CustomerTableView ()

@property (nonatomic, strong) CustomerHeaderView* sectionHeader; //section头部, 用来显示多少用户正在浏览当前经纪人熟悉的小区房源

@end

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
    
    if (self.data.count == 1) { //如果只有一条数据
        [cell showTopLine];
        [cell showBottonLineWithCellHeight:84];
    }else if(self.data.count > 1){ //如果有两条以上数据
        
        if (indexPath.row == 0) {
            [cell showTopLine];
            [cell showBottonLineWithCellHeight:84 andOffsetX:15];
        }else if (indexPath.row == self.data.count-1) {
            [cell hideTopLine];
            [cell showBottonLineWithCellHeight:84];
        }else{
            [cell hideTopLine];
            [cell showBottonLineWithCellHeight:84 andOffsetX:15];
        }
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
    if (_sectionHeader == nil) {
        _sectionHeader = [[CustomerHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    }
    _sectionHeader.customerListModel = self.customerListModel;
    [_sectionHeader setNeedsLayout];
    
    return _sectionHeader;
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
