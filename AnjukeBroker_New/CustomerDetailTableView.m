//
//  CustomerDetailTableView.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "CustomerDetailTableView.h"
#import "FavoritePropertyTableViewCell.h"
#import "FavoritePropertyModel.h"

#import "CustomerDetailTableViewCell.h"
#import "CustomerDetailModel.h"

#import "UIImageView+WebCache.h"
#import "UIViewExt.h"

#import "CustomerDetailHeaderView.h"


@interface CustomerDetailTableView ()

@property (nonatomic, strong) CustomerDetailHeaderView* firstSectionHeader;
@property (nonatomic, strong) UIView* secondSectionHeader;

@end

@implementation CustomerDetailTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor brokerBgPageColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        static NSString* identifier = @"CustomerDetailTableViewCell";
        CustomerDetailTableViewCell* cell = [[CustomerDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.customerDetailModel = self.customerDetailModel;
    
        [cell showTopLine];
        if (self.customerDetailModel.comm_preference && self.customerDetailModel.lineHeight > 20) {
            [cell showBottonLineWithCellHeight:105];
        }else{
            [cell showBottonLineWithCellHeight:90];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell不可选中
        return cell;
        
    }else{
        
        static NSString* identifier = @"FavoritePropertyTableViewCell";
        FavoritePropertyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[FavoritePropertyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        FavoritePropertyModel* favorite = (FavoritePropertyModel*)[self.data objectAtIndex:indexPath.row];
        cell.favoritePropertyModel = favorite;
        
        if (indexPath.row == 0) {
            [cell showTopLine];
        }
        
        if (indexPath.row == self.data.count-1) {
            [cell showBottonLineWithCellHeight:90];
        }else{
            [cell showBottonLineWithCellHeight:90 andOffsetX:15];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell不可选中
        
        
        return cell;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0
        && indexPath.section == 0
        && self.customerDetailModel.comm_preference
        && self.customerDetailModel.lineHeight > 20) { //偏好房源字段的长度如果超过20,需要二行显示,对应的此cell高度增加
        return 105;
    }
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.customerDetailModel.view_prop_info.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (self.data.count > 0) {
        if (section == 0) {
            return 80;
        }else{
            return 36;
        }
//    }else{
//        return 0;
//    }
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        if (_firstSectionHeader == nil) {
            _firstSectionHeader = [[CustomerDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
        }
        _firstSectionHeader.customerDetailModel = self.customerDetailModel;
        [_firstSectionHeader setNeedsLayout];
        return _firstSectionHeader;
        
    }else{
        
        if (_secondSectionHeader == nil) {
            _secondSectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 36)];
            _secondSectionHeader.backgroundColor = [UIColor brokerBgPageColor];
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-15, 36)];
            [_secondSectionHeader addSubview:label];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont ajkH4Font];
            label.textColor = [UIColor brokerLightGrayColor];
            label.text = [NSString stringWithFormat:@"正在浏览的房源"];
//            [label sizeToFit];
        }
        
        return _secondSectionHeader;
    }
    
}

#pragma mark -
#pragma mark 解决section不跟随tableView移动的问题
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 80;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


@end
