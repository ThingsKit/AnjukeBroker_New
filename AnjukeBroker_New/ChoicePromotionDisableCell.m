//
//  ChoicePromotionDisableCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-2.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//
#define GAP_HORIZONTAL 15
#define GAP_VERTICAL 8

#import "ChoicePromotionDisableCell.h"

@interface ChoicePromotionDisableCell ()

@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong) UIImageView* face;
@property (nonatomic, strong) UILabel* mainTitle;
@property (nonatomic, strong) UILabel* subTitle;

@end


@implementation ChoicePromotionDisableCell

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
    
    //图片
    _face = [[UIImageView alloc] initWithFrame:CGRectZero];
    _face.backgroundColor = [UIColor clearColor];
    _face.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_face];
    
    //主标题
    _mainTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _mainTitle.backgroundColor = [UIColor clearColor];
    _mainTitle.font = [UIFont ajkH3Font_B];
    _mainTitle.textColor = [UIColor brokerBlackColor];
    [self.contentView addSubview:_mainTitle];
    
    //副标题
    _subTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _subTitle.backgroundColor = [UIColor clearColor];
    _subTitle.font = [UIFont ajkH5Font];
    _subTitle.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_subTitle];
    
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
    _title.text = @"精选推广";
    [_title sizeToFit];
    
    //图片anjuke_icon_tips_sad
    _face.frame = CGRectMake(20, 125 - 60 -18, 60, 60);
    _face.image = [UIImage imageNamed:@"broker_property_sad"];
    
    //主标题
    _mainTitle.frame = CGRectMake(20 + 60 + 15, 55, 100, 20);
    _mainTitle.text = @"不符合精选推广条件!";
    [_mainTitle sizeToFit];
    
    //副标题
    _subTitle.frame = CGRectMake(20 + 60 + 15, 65 + 15, 100, 20);
//    _subTitle.text = @"精选推广条件: 多图+新发15天";
    _subTitle.text = self.choiceConditionText;
    [_subTitle sizeToFit];
    
    
}

@end
