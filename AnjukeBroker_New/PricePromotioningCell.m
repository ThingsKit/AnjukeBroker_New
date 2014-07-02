//
//  PricePromotionCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//
#define GAP_HORIZONTAL 15
#define GAP_VERTICAL 6

#import "PricePromotioningCell.h"
#import "PricePromotionCellModel.h"
#import "UIViewExt.h"

@interface PricePromotioningCell ()

@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong) UILabel* todayClickNumber; //今日点击
@property (nonatomic, strong) UILabel* todayClick;
@property (nonatomic, strong) UILabel* totalClickNumber; //总点击
@property (nonatomic, strong) UILabel* totalClick;
@property (nonatomic, strong) UILabel* unitNumber; //点击单价
@property (nonatomic, strong) UILabel* unit;

@end


@implementation PricePromotioningCell

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
    _title.font = [UIFont ajkH2Font];
    _title.textColor = [UIColor brokerBlackColor];
    [self.contentView addSubview:_title];
    
    //今日点击数字
    _todayClickNumber = [[UILabel alloc] initWithFrame:CGRectZero];
    _todayClickNumber.backgroundColor = [UIColor clearColor];
    _todayClickNumber.font = [UIFont ajkH1Font];
    _todayClickNumber.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_todayClickNumber];
    
    //总点击数字
    _totalClickNumber = [[UILabel alloc] initWithFrame:CGRectZero];
    _totalClickNumber.backgroundColor = [UIColor clearColor];
    _totalClickNumber.font = [UIFont ajkH1Font];
    _totalClickNumber.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_totalClickNumber];
    
    //点击单价数字
    _unitNumber = [[UILabel alloc] initWithFrame:CGRectZero];
    _unitNumber.backgroundColor = [UIColor clearColor];
    _unitNumber.font = [UIFont ajkH1Font];
    _unitNumber.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_unitNumber];
    
    //今日点击
    _todayClick = [[UILabel alloc] initWithFrame:CGRectZero];
    _todayClick.backgroundColor = [UIColor clearColor];
    _todayClick.font = [UIFont ajkH5Font];
    _todayClick.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_todayClick];
    
    //总点击
    _totalClick = [[UILabel alloc] initWithFrame:CGRectZero];
    _totalClick.backgroundColor = [UIColor clearColor];
    _totalClick.font = [UIFont ajkH5Font];
    _totalClick.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_totalClick];
    
    //点击单价
    _unit = [[UILabel alloc] initWithFrame:CGRectZero];
    _unit.backgroundColor = [UIColor clearColor];
    _unit.font = [UIFont ajkH5Font];
    _unit.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_unit];
    
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
    _title.frame = CGRectMake(20, 15, 100, 20);
    _title.text = @"定价推广";
    [_title sizeToFit];
    
    //今日点击数字
    _todayClickNumber.frame = CGRectMake(20, _title.bottom + GAP_VERTICAL, 100, 20);
    _todayClickNumber.text = self.pricePromotionCellModel.todayClicks;
    [_todayClickNumber sizeToFit];
    
    //总点击数字
    _totalClickNumber.frame = CGRectMake(100, _title.bottom + GAP_VERTICAL, 100, 20);
    _totalClickNumber.text = self.pricePromotionCellModel.totalClicks;
    [_totalClickNumber sizeToFit];
    
    //点击单价数字
    _unitNumber.frame = CGRectMake(175, _title.bottom + GAP_VERTICAL, 100, 20);
    _unitNumber.text = [NSString stringWithFormat:@"%@", self.pricePromotionCellModel.clickPrice];
    [_unitNumber sizeToFit];
    
    int labelY = 68;
    
    //今日点击
    _todayClick.frame = CGRectMake(20, labelY, 100, 20);
    _todayClick.text = @"今日点击";
    [_todayClick sizeToFit];
    
    //总点击
    _totalClick.frame = CGRectMake(100, labelY, 100, 20);
    _totalClick.text = @"总点击";
    [_totalClick sizeToFit];
    
    //点击单价
    _unit.frame = CGRectMake(175, labelY , 100, 20);
    _unit.text = @"点击单价";
    [_unit sizeToFit];
    
}

@end
