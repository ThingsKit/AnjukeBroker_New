//
//  PricePromotionableCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-2.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "PricePromotionableCell.h"
#import "PricePromotionCellModel.h"
#import "UIViewExt.h"

@interface PricePromotionableCell ()

@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong) UILabel* unitNumber; //点击单价
@property (nonatomic, strong) UIButton* promotionButton; //推广按钮

@end


@implementation PricePromotionableCell

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
    
    //点击单价
    _unitNumber = [[UILabel alloc] initWithFrame:CGRectZero];
    _unitNumber.backgroundColor = [UIColor clearColor];
    _unitNumber.font = [UIFont ajkH3Font];
    _unitNumber.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_unitNumber];
    
    //推广按钮
    _promotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_promotionButton addTarget:self action:@selector(startPromotion:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_promotionButton];
    
    //cell的背景视图, 默认选中是蓝色
    //    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    //    backgroundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    //    self.selectedBackgroundView = backgroundView;
    
    self.contentView.backgroundColor = [UIColor brokerWhiteColor];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //标题
    _title.frame = CGRectMake(20, 15, 100, 20);
    _title.text = @"定价推广";
    [_title sizeToFit];
    
    //点击单价数字
    _unitNumber.frame = CGRectMake(20, _title.bottom + 3, 100, 20);
    _unitNumber.text = [NSString stringWithFormat:@"点击单价: %@%@", self.pricePromotionCellModel.clickPrice, self.pricePromotionCellModel.clickPriceUnit];
    [_unitNumber sizeToFit];
    
    //推广按钮
    _promotionButton.frame = CGRectMake(15, 120 - 15 - 42, ScreenWidth-15*2, 42);
    [_promotionButton setTitle:@"立即推广" forState:UIControlStateNormal];
    _promotionButton.titleLabel.font = [UIFont ajkH2Font];
    [_promotionButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateNormal];
    [_promotionButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_press"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateHighlighted];
    _promotionButton.tag = 20;
    _promotionButton.enabled = YES;
    
}

- (void)startPromotion:(UIButton*)button{
    NSLog(@"立即推广");
    if (self.block != nil) {
        _block(button);
    }
    
}


@end
