//
//  ChoicePromotioningCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-2.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//
#define GAP_HORIZONTAL 15
#define GAP_VERTICAL 8

#import "ChoicePromotioningCell.h"
#import "ChoicePromotionCellModel.h"
#import "UIViewExt.h"

@interface ChoicePromotioningCell ()

@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong) UILabel* todayClickNumber; //今日点击
@property (nonatomic, strong) UILabel* todayClick;
@property (nonatomic, strong) UILabel* totalClickNumber; //总点击
@property (nonatomic, strong) UILabel* totalClick;
@property (nonatomic, strong) UILabel* budgetNumber; //预算余额
@property (nonatomic, strong) UILabel* budget;
@property (nonatomic, strong) UILabel* unitNumber; //点击单价
@property (nonatomic, strong) UILabel* unit;
@property (nonatomic, strong) UIButton* promotionButton; //推广按钮

@end


@implementation ChoicePromotioningCell

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
    
    //预算余额数字
    _budgetNumber = [[UILabel alloc] initWithFrame:CGRectZero];
    _budgetNumber.backgroundColor = [UIColor clearColor];
    _budgetNumber.font = [UIFont ajkH1Font];
    _budgetNumber.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_budgetNumber];
    
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
    
    //预算余额
    _budget = [[UILabel alloc] initWithFrame:CGRectZero];
    _budget.backgroundColor = [UIColor clearColor];
    _budget.font = [UIFont ajkH5Font];
    _budget.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_budget];
    
    //点击单价
    _unit = [[UILabel alloc] initWithFrame:CGRectZero];
    _unit.backgroundColor = [UIColor clearColor];
    _unit.font = [UIFont ajkH5Font];
    _unit.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_unit];
    
    //推广按钮
    _promotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_promotionButton setTitle:@"结束精选推广" forState:UIControlStateNormal];
    [_promotionButton setTitleColor:[UIColor brokerBabyBlueColor] forState:UIControlStateNormal];
    [_promotionButton setTitleColor:[UIColor brokerBlueGrayColor] forState:UIControlStateHighlighted];
    _promotionButton.titleLabel.font = [UIFont ajkH2Font];
    
    [_promotionButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_hollow"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateNormal];
    [_promotionButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_hollow_press"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateHighlighted];
    [_promotionButton addTarget:self action:@selector(startPromotion:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_promotionButton];
    
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
    
    //今日点击数字
    _todayClickNumber.frame = CGRectMake(20, _title.bottom + GAP_VERTICAL, 100, 20);
    _todayClickNumber.text = self.choicePromotionModel.todayClicks;
    [_todayClickNumber sizeToFit];
    
    //总点击数字
    _totalClickNumber.frame = CGRectMake(95, _title.bottom + GAP_VERTICAL, 100, 20);
    _totalClickNumber.text = self.choicePromotionModel.totalClicks;
    [_totalClickNumber sizeToFit];
    
    //预算余额数字
    _budgetNumber.frame = CGRectMake(175, _title.bottom + GAP_VERTICAL, 100, 20);
    _budgetNumber.text = self.choicePromotionModel.balance;
    [_budgetNumber sizeToFit];
    
    //点击单价数字
    _unitNumber.frame = CGRectMake(250, _title.bottom + GAP_VERTICAL, 100, 20);
    _unitNumber.text = [NSString stringWithFormat:@"%@", self.choicePromotionModel.clickPrice];
    [_unitNumber sizeToFit];
    
    int labelY = 70;
    //今日点击
    _todayClick.frame = CGRectMake(20, labelY, 100, 20);
    _todayClick.text = @"今日点击";
    [_todayClick sizeToFit];
    
    //总点击
    _totalClick.frame = CGRectMake(95, labelY, 100, 20);
    _totalClick.text = @"总点击";
    [_totalClick sizeToFit];
    
    //预算余额
    _budget.frame = CGRectMake(175, labelY, 100, 20);
    _budget.text = @"预算余额";
    [_budget sizeToFit];
    
    //点击单价
    _unit.frame = CGRectMake(250, labelY, 100, 20);
    _unit.text = @"点击单价";
    [_unit sizeToFit];
    
    //推广按钮
    _promotionButton.frame = CGRectMake(15, 150 - (15+42), ScreenWidth-15*2, 42);
    
}

- (void)startPromotion:(UIButton*)button{
    NSLog(@"结束推广");
    if (self.block != nil) {
        _block(button);
    }
    
}


@end
