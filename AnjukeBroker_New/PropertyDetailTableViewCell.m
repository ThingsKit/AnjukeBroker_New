//
//  PropertyDetailTableViewCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PropertyDetailTableViewCell.h"
#import "PropertyDetailTableViewCellModel.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"

#define GAP_H 6
#define GAP_V 8

@interface PropertyDetailTableViewCell ()

@property (nonatomic, strong) UIImageView* propertyIcon; //房源图片
@property (nonatomic, strong) UILabel* propertyTitle; //房源标题
@property (nonatomic, strong) UILabel* community; //小区名称
@property (nonatomic, strong) UILabel* houseType; //户型
@property (nonatomic, strong) UILabel* area; //面积
@property (nonatomic, strong) UILabel* price; //售价
@property (nonatomic, strong) UIImageView* multiPictureIcon; //多图图标
@property (nonatomic, strong) UIImageView* choiceIcon; //精选推广图标
@property (nonatomic, strong) UIImageView* mobileIcon; //手机发图图标

@end


@implementation PropertyDetailTableViewCell

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
    
    //房源图像
    _propertyIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _propertyIcon.backgroundColor = [UIColor clearColor];
    _propertyIcon.contentMode = UIViewContentModeScaleAspectFit;
    _propertyIcon.layer.cornerRadius = 4.0f;
    _propertyIcon.layer.masksToBounds = YES;
    [self.contentView addSubview:_propertyIcon];
    
    //房源标题
    _propertyTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _propertyTitle.backgroundColor = [UIColor clearColor];
    _propertyTitle.font = [UIFont ajkH2Font];
    [_propertyTitle setTextColor:[UIColor brokerBlackColor]];
    [self.contentView addSubview:_propertyTitle];
    
    //多图, 精选, 手机
    _multiPictureIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_multiPictureIcon];
    
    _choiceIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_choiceIcon];
    
    _mobileIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_mobileIcon];
    
    //小区名称
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
    _price.font = [UIFont ajkH4Font];
    [_price setTextColor:[UIColor brokerLightGrayColor]];
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
    
    //房源图片
    _propertyIcon.frame = CGRectMake(15, 15, 80, 60);
    NSString* iconPath = self.propertyDetailTableViewCellModel.imgURL;
    if (iconPath != nil && ![@"" isEqualToString:iconPath]) {
        //加载图片
        [_propertyIcon setImageWithURL:[NSURL URLWithString:iconPath] placeholderImage:[UIImage imageNamed:@"anjuke61_bg4"]];
    }else{
        _propertyIcon.image = [UIImage imageNamed:@"anjuke61_bg4"]; //默认图片
    }
    
    //房源标题
    _propertyTitle.frame = CGRectMake(_propertyIcon.right + 12, 15, 130, 20);
    _propertyTitle.text = self.propertyDetailTableViewCellModel.title;
    //    _userName.backgroundColor = [UIColor redColor];
    
    //多图
    if ([@"1" isEqualToString:self.propertyDetailTableViewCellModel.isMoreImg]) {
        _multiPictureIcon.frame = CGRectMake(_propertyTitle.right, 15, 17, 17);
        _multiPictureIcon.image = [UIImage imageNamed:@"broker_property_icon_pic"];
        _multiPictureIcon.hidden = NO;
    }else{
        _multiPictureIcon.hidden = YES;
    }
    
    //精选
    if ([@"1" isEqualToString:self.propertyDetailTableViewCellModel.isChoice]) {
        if (self.propertyDetailTableViewCellModel.isMoreImg && self.propertyDetailTableViewCellModel.isMoreImg.length > 0) {
            _choiceIcon.frame = CGRectMake(_multiPictureIcon.right + 2, 15, 17, 17);
            _choiceIcon.image = [UIImage imageNamed:@"broker_property_icon_jx"];
            _choiceIcon.hidden = NO;
        }else{
            _choiceIcon.frame = CGRectMake(_propertyTitle.right, 15, 17, 17);
            _choiceIcon.image = [UIImage imageNamed:@"broker_property_icon_jx"];
            _choiceIcon.hidden = NO;
        }
    }else{
        _choiceIcon.hidden = YES;
    }
    
    //手机
    if ([@"1" isEqualToString:self.propertyDetailTableViewCellModel.isPhonePub]) {
        if (self.propertyDetailTableViewCellModel.isChoice && self.propertyDetailTableViewCellModel.isChoice.length > 0) {
            _mobileIcon.frame = CGRectMake(_choiceIcon.right + 2, 15, 17, 17);
            _mobileIcon.image = [UIImage imageNamed:@"broker_property_icon_tel"];
            _mobileIcon.hidden = NO;
        }else if(self.propertyDetailTableViewCellModel.isMoreImg && self.propertyDetailTableViewCellModel.isMoreImg.length > 0){
            _mobileIcon.frame = CGRectMake(_multiPictureIcon.right + 2, 15, 17, 17);
            _mobileIcon.image = [UIImage imageNamed:@"broker_property_icon_tel"];
            _mobileIcon.hidden = NO;
        }else{
            _mobileIcon.frame = CGRectMake(_propertyTitle.right, 15, 17, 17);
            _mobileIcon.image = [UIImage imageNamed:@"broker_property_icon_tel"];
            _mobileIcon.hidden = NO;
        }
        
    }else{
        _mobileIcon.hidden = YES;
    }
    
    
    //小区名称
    _community.frame = CGRectMake(_propertyIcon.right + 12, _propertyTitle.bottom + GAP_V, 100, 16);
    _community.text = self.propertyDetailTableViewCellModel.commName;
    //    _community.backgroundColor = [UIColor redColor];
    //    [_community sizeToFit];
    
    //户型
    _houseType.frame = CGRectMake(_propertyIcon.right + 12, _community.bottom + GAP_V, 100, 20);
    _houseType.text = [NSString stringWithFormat:@"%@室%@厅%@卫", self.propertyDetailTableViewCellModel.roomNum, self.propertyDetailTableViewCellModel.hallNum, self.propertyDetailTableViewCellModel.toiletNum];
    [_houseType sizeToFit];
    
    //面积
    _area.frame = CGRectMake(_houseType.right + GAP_H, _community.bottom + GAP_V, 100, 20);
    _area.text = [NSString stringWithFormat:@"%@平", self.propertyDetailTableViewCellModel.area];
    [_area sizeToFit];
    
    //租金或售价
    _price.frame = CGRectMake(_area.right + GAP_H, _community.bottom + GAP_V, 100, 20);
    _price.text = [NSString stringWithFormat:@"%@%@", self.propertyDetailTableViewCellModel.price, self.propertyDetailTableViewCellModel.priceUnit];
    [_price sizeToFit];
    //    _price.backgroundColor = [UIColor redColor];
    
}

@end
