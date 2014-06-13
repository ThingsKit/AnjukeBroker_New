//
//  CustomerDetailTableViewCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "FavoritePropertyTableViewCell.h"
#import "FavoritePropertyModel.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"

#define GAP_H 6
#define GAP_V 3

@interface FavoritePropertyTableViewCell ()

@property (nonatomic, strong) UIImageView* propertyIcon; //房源图片
@property (nonatomic, strong) UILabel* propertyTitle; //房源标题
@property (nonatomic, strong) UILabel* location; //房源所属板块
@property (nonatomic, strong) UILabel* community; //房源所属小区
@property (nonatomic, strong) UILabel* houseType; //户型
@property (nonatomic, strong) UILabel* area; //面积
@property (nonatomic, strong) UILabel* price; //售价

@end


@implementation FavoritePropertyTableViewCell

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
    
    //用户头像
    _propertyIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _propertyIcon.backgroundColor = [UIColor clearColor];
    _propertyIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_propertyIcon];
    
    //用户名称
    _propertyTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _propertyTitle.backgroundColor = [UIColor clearColor];
    _propertyTitle.font = [UIFont ajkH2Font];
    [_propertyTitle setTextColor:[UIColor brokerBlackColor]];
    [self.contentView addSubview:_propertyTitle];
    
    //地点
    _location = [[UILabel alloc] initWithFrame:CGRectZero];
    _location.backgroundColor = [UIColor clearColor];
    _location.font = [UIFont ajkH4Font];
    [_location setTextColor:[UIColor brokerLightGrayColor]];
    [self.contentView addSubview:_location];
    
    //小区
    _community = [[UILabel alloc] initWithFrame:CGRectZero];
    _community.backgroundColor = [UIColor clearColor];
    _community.font = [UIFont ajkH4Font];
    _community.textColor = [UIColor brokerLightGrayColor];
    [self.contentView addSubview:_community];
    
    //户型
    _houseType = [[UILabel alloc] initWithFrame:CGRectZero];
    _houseType.backgroundColor = [UIColor clearColor];
    _houseType.font = [UIFont ajkH4Font];
    [_houseType setTextColor:[UIColor brokerLightGrayColor]];
    [self.contentView addSubview:_houseType];
    
    //面积
    _area = [[UILabel alloc] initWithFrame:CGRectZero];
    _area.backgroundColor = [UIColor clearColor];
    _area.font = [UIFont ajkH4Font];
    _area.textColor = [UIColor brokerLightGrayColor];
    [self.contentView addSubview:_area];
    
    //租金或售价
    _price = [[UILabel alloc] initWithFrame:CGRectZero];
    _price.backgroundColor = [UIColor clearColor];
    _price.font = [UIFont ajkH2Font];
    [_price setTextColor:[UIColor brokerBlackColor]];
    [self.contentView addSubview:_price];
    
//cell的背景视图
//    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
//    backgroundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
//    self.selectedBackgroundView = backgroundView;
    
}


//加载数据
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //房源图片
    _propertyIcon.frame = CGRectMake(15, 15, 80, 60);
    NSString* iconPath = self.favoritePropertyModel.propertyIcon;
    if (iconPath != nil && ![@"" isEqualToString:iconPath]) {
        //加载图片
        [_propertyIcon setImageWithURL:[NSURL URLWithString:iconPath] placeholderImage:[UIImage imageNamed:@"anjuke_icon_headpic"]];
    }else{
        _propertyIcon.image = [UIImage imageNamed:@"anjuke_icon_headpic"]; //默认图片
    }
    
    //房源标题
    _propertyTitle.frame = CGRectMake(_propertyIcon.right + 12, 15, 190, 20);
    _propertyTitle.text = self.favoritePropertyModel.propertyTitle;
    //    _userName.backgroundColor = [UIColor redColor];
    
    //地点
    _location.frame = CGRectMake(_propertyIcon.right + 12, _propertyTitle.bottom + GAP_V, 100, 20);
    _location.text = self.favoritePropertyModel.location;
    [_location sizeToFit]; //大小自适应
    //    _location.backgroundColor = [UIColor purpleColor];
    
    //小区
    _community.frame = CGRectMake(_location.right + GAP_H, _propertyTitle.bottom + GAP_V, 100, 20);
    _community.text = self.favoritePropertyModel.community;
    [_community sizeToFit];
    
    //户型
    _houseType.frame = CGRectMake(_propertyIcon.right + 12, _location.bottom + GAP_V, 100, 20);
    _houseType.text = [NSString stringWithFormat:@"%@室%@厅%@卫", self.favoritePropertyModel.room, self.favoritePropertyModel.hall, self.favoritePropertyModel.toilet];
    [_houseType sizeToFit];
    //    _houseType.backgroundColor = [UIColor grayColor];
    
    //面积
    _area.frame = CGRectMake(_houseType.right + GAP_H, _location.bottom + GAP_V, 100, 20);
    _area.text = [NSString stringWithFormat:@"%@平米", self.favoritePropertyModel.area];
    [_area sizeToFit];
    
    //租金或售价
    _price.frame = CGRectMake(ScreenWidth - 90, _location.bottom + GAP_V - 1, 70, 20);
    _price.textAlignment = NSTextAlignmentRight;
    _price.text = self.favoritePropertyModel.price;
//    [_price sizeToFit];
//    _price.backgroundColor = [UIColor redColor];
    
}

@end
