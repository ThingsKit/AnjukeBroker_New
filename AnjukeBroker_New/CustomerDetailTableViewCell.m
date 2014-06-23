//
//  CustomerDetailTableViewCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CustomerDetailTableViewCell.h"
#import "UIViewExt.h"
#import "CustomerDetailModel.h"

#define GAP_H 6
#define GAP_V 6

@interface CustomerDetailTableViewCell ()

@property (nonatomic, strong) UILabel* title; //目前是找房偏好
@property (nonatomic, strong) UILabel* community; //偏爱小区
@property (nonatomic, strong) UILabel* houseType; //偏爱户型
@property (nonatomic, strong) UILabel* price; //偏爱价格
//@property (nonatomic, strong) UILabel* priceUnit; //价格单位

@end

@implementation CustomerDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

#pragma mark -
#pragma mark UI相关

- (void)initCell {
    
    //标题
    _title = [[UILabel alloc] initWithFrame:CGRectZero];
    _title.backgroundColor = [UIColor clearColor];
    _title.font = [UIFont ajkH4Font];
    _title.textColor = [UIColor brokerLightGrayColor];
    [self.contentView addSubview:_title];
    
    //偏爱小区
    _community = [[UILabel alloc] initWithFrame:CGRectZero];
    _community.backgroundColor = [UIColor clearColor];
    _community.font = [UIFont ajkH3Font];
    _community.textColor = [UIColor brokerBlackColor];
    _community.numberOfLines = 0;
    [self.contentView addSubview:_community];
    
    //户型
    _houseType = [[UILabel alloc] initWithFrame:CGRectZero];
    _houseType.backgroundColor = [UIColor clearColor];
    _houseType.font = [UIFont ajkH3Font];
    _houseType.textColor = [UIColor brokerBlackColor];
    [self.contentView addSubview:_houseType];
    
    //售价
    _price = [[UILabel alloc] initWithFrame:CGRectZero];
    _price.backgroundColor = [UIColor clearColor];
    _price.font = [UIFont ajkH3Font];
    _price.textColor = [UIColor brokerBlackColor];
    [self.contentView addSubview:_price];

    //cell的背景视图, 默认选中是蓝色
//    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
//    backgroundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
//    self.selectedBackgroundView = backgroundView;
    
    self.contentView.backgroundColor = [UIColor brokerWhiteColor];
    
}


//加载数据
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //标题
    _title.frame = CGRectMake(15, 13, 100, 20);
    _title.text = @"找房偏好";
//    _title.backgroundColor = [UIColor redColor];
    [_title sizeToFit];
    
    //偏爱小区
    CGSize communitySize = [self.customerDetailModel.comm_preference sizeWithFont:_community.font constrainedToSize:CGSizeMake(ScreenWidth - 15*2, 40)];
    self.customerDetailModel.lineHeight = communitySize.height;
    _community.frame = CGRectMake(15, _title.bottom + GAP_V, communitySize.width, communitySize.height);
    _community.text = self.customerDetailModel.comm_preference;
    [_community sizeToFit];
    
    //户型
    _houseType.frame = CGRectMake(15, _community.bottom + GAP_V, 100, 20);
    _houseType.text = self.customerDetailModel.house_type_preference;
    [_houseType sizeToFit];
    
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(_houseType.right + GAP_H, _community.bottom + GAP_V + 2, 1, 15)];
    line.layer.borderColor = [UIColor brokerLineColor].CGColor;
    line.layer.borderWidth = 0.5;
    [self.contentView addSubview:line];
    
    //售价
    _price.frame = CGRectMake(line.right + GAP_H, _community.bottom + GAP_V, 100, 20);
    _price.text = self.customerDetailModel.price_preference;
    [_price sizeToFit];
    
}

@end
