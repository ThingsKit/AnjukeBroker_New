//
//  ChoicePromotionQueuingCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-2.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#define GAP_HORIZONTAL 15
#define GAP_VERTICAL 10

#import "ChoicePromotionQueuingCell.h"

@interface ChoicePromotionQueuingCell ()

@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong) UILabel* subTitlePrefix;
@property (nonatomic, strong) UILabel* number;
@property (nonatomic, strong) UILabel* subTitleSuffix;
@property (nonatomic, strong) UIButton* cancelQueueButton; //取消排队

@end

@implementation ChoicePromotionQueuingCell

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
    
    //排队情况
    _subTitlePrefix = [[UILabel alloc] initWithFrame:CGRectZero];
    _subTitlePrefix.backgroundColor = [UIColor clearColor];
    _subTitlePrefix.font = [UIFont ajkH3Font];
    _subTitlePrefix.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_subTitlePrefix];
    
    
    _number = [[UILabel alloc] initWithFrame:CGRectZero];
    _number.backgroundColor = [UIColor clearColor];
    _number.font = [UIFont ajkH3Font];
    _number.textColor = [UIColor brokerBabyBlueColor];
    [self.contentView addSubview:_number];
    
    _subTitleSuffix = [[UILabel alloc] initWithFrame:CGRectZero];
    _subTitleSuffix.backgroundColor = [UIColor clearColor];
    _subTitleSuffix.font = [UIFont ajkH3Font];
    _subTitleSuffix.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_subTitleSuffix];
    
    //推广按钮
    _cancelQueueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelQueueButton setTitle:@"取消排队" forState:UIControlStateNormal];
    [_cancelQueueButton setTitleColor:[UIColor brokerBabyBlueColor] forState:UIControlStateNormal];
    [_cancelQueueButton setTitleColor:[UIColor brokerBlueGrayColor] forState:UIControlStateHighlighted];
    _cancelQueueButton.titleLabel.font = [UIFont ajkH2Font];
    
    [_cancelQueueButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_hollow"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateNormal];
    [_cancelQueueButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_hollow_press"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateHighlighted];
    [_cancelQueueButton addTarget:self action:@selector(startPromotion:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_cancelQueueButton];
    
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
    _title.text = @"精选推广";
    [_title sizeToFit];
    
    //排队情况
    _subTitlePrefix.frame = CGRectMake(20, _title.bottom + GAP_VERTICAL, 100, 20);
    _subTitlePrefix.text = @"排在第";
    [_subTitlePrefix sizeToFit];
    
    _number.frame = CGRectMake(_subTitlePrefix.right, _title.bottom + GAP_VERTICAL, 100, 20);
    _number.text = self.queuePosition;
    [_number sizeToFit];
    
    _subTitleSuffix.frame = CGRectMake(_number.right, _title.bottom + GAP_VERTICAL, 100, 20);
    _subTitleSuffix.text = @"位, 马上就能推广啦!";
    [_subTitleSuffix sizeToFit];
    
    //推广按钮
    _cancelQueueButton.frame = CGRectMake(15, 150 - (15+42), ScreenWidth-15*2, 42);
    
}

- (void)startPromotion:(UIButton*)button{
    NSLog(@"取消排队");
    if (self.block != nil) {
        _block(button);
    }
    
}




@end
