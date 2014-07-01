//
//  ChoicePromotionCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//
#define GAP_HORIZONTAL 6
#define GAP_VERTICAL 6

#import "ChoicePromotionCell.h"
#import "ChoicePromotionCellModel.h"

@interface ChoicePromotionCell ()

@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong) UILabel* promotionStatus; //当前推广状态
@property (nonatomic, strong) UILabel* unitNumber; //点击单价
@property (nonatomic, strong) UILabel* promotionVacancy; //推广位
@property (nonatomic, strong) UILabel* queueVacancy; //排队位
@property (nonatomic, strong) NSMutableArray* buckets; //坑位数组
@property (nonatomic, strong) UIImageView* cursor; //游标
@property (nonatomic, strong) UIView* bucketContentView; //坑位内容视图
@property (nonatomic, strong) UIButton* promotionButton; //推广按钮

@end

@implementation ChoicePromotionCell

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
    
    //当前推广状态
    _promotionStatus = [[UILabel alloc] initWithFrame:CGRectZero];
    _promotionStatus.backgroundColor = [UIColor clearColor];
    _promotionStatus.font = [UIFont ajkH3Font];
    _promotionStatus.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_promotionStatus];
    
    //点击单价
    _unitNumber = [[UILabel alloc] initWithFrame:CGRectZero];
    _unitNumber.backgroundColor = [UIColor clearColor];
    _unitNumber.font = [UIFont ajkH3Font];
    _unitNumber.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_unitNumber];
    
    //推广位
    _promotionVacancy = [[UILabel alloc] initWithFrame:CGRectZero];
    _promotionVacancy.backgroundColor = [UIColor clearColor];
    _promotionVacancy.font = [UIFont ajkH3Font];
    _promotionVacancy.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_promotionVacancy];
    
    //排队位
    _queueVacancy = [[UILabel alloc] initWithFrame:CGRectZero];
    _queueVacancy.backgroundColor = [UIColor clearColor];
    _queueVacancy.font = [UIFont ajkH3Font];
    _queueVacancy.textColor = [UIColor brokerMiddleGrayColor];
    [self.contentView addSubview:_queueVacancy];
    
    //坑位图
    _bucketContentView = [[UIView alloc] initWithFrame:CGRectZero];
    _bucketContentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_bucketContentView];
    
    //坑位数组
    _buckets = [NSMutableArray arrayWithCapacity:12];
    
    //推广按钮
    _promotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_promotionButton setTitle:@"立即推广" forState:UIControlStateNormal];
    [_promotionButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateNormal];
    [_promotionButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_press"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateHighlighted];
    _promotionButton.frame = CGRectMake(15, 14, ScreenWidth-15*2, 42);
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
    
    //推广状态
    _promotionStatus.frame = CGRectMake(20, _title.bottom + GAP_VERTICAL, 100, 20);
    if ([@"3" isEqualToString:self.choicePromotionModel.actionType]) { //可推广
        _promotionStatus.text = @"可立即推广";
        [_promotionStatus sizeToFit];
    }
    
    //点击单价
    _unitNumber.frame = CGRectMake(_promotionStatus.right + GAP_HORIZONTAL, _title.bottom + GAP_VERTICAL, 100, 20);
    _unitNumber.text = [NSString stringWithFormat:@"点击单价: %@%@", self.choicePromotionModel.clickPrice, self.choicePromotionModel.clickPriceUnit];
    [_unitNumber sizeToFit];
    
    //推广位
    _promotionVacancy.frame = CGRectMake(20, _unitNumber.bottom + GAP_VERTICAL, 100, 20);
    _promotionVacancy.text = @"推广位";
    [_promotionVacancy sizeToFit];
    
    //排队位
    _queueVacancy.frame = CGRectMake(20, _promotionVacancy.bottom + GAP_VERTICAL, 100, 20);
    _queueVacancy.text = @"排队位";
    [_queueVacancy sizeToFit];
    
    //坑位内容
    _bucketContentView.frame = CGRectMake(_promotionVacancy.right + GAP_HORIZONTAL, _unitNumber.bottom + GAP_VERTICAL, 200, 60);
    
    int total = [self.choicePromotionModel.maxBucketNum intValue];
    int used = [self.choicePromotionModel.useNum intValue];
    int column = 6;
    int row = (total + column -1)/column;
    
    for (int i = 0; i < total; i++) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 21)];
        [_buckets addObject:imageView];
    }
    
    
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < column; j++) {
            if ((i*column + j) < used) {
                UIImageView* imageView = [_buckets objectAtIndex:(i*column + j)];
                imageView.frame = CGRectMake(j*30, i*30, 25, 21);
                imageView.image = [UIImage imageNamed:@"broker_property_house_blue"];
                [_bucketContentView addSubview:imageView];
                
            }else if((i*column + j) == used){
                UIImageView* imageView = [_buckets objectAtIndex:(i*column + j)];
                imageView.frame = CGRectMake(j*30, i*30, 25, 21);
                imageView.image = [UIImage imageNamed:@"broker_property_house_now"];
                [_bucketContentView addSubview:imageView];
                
                _cursor = [[UIImageView alloc] initWithFrame:CGRectMake(j*30, i*30 + 10, 10, 5)];
                _cursor.image = [UIImage imageNamed:@"broker_property_house_arrow"];
                [_bucketContentView addSubview:_cursor];
                
            }else{
                UIImageView* imageView = [_buckets objectAtIndex:(i*column + j)];
                imageView.frame = CGRectMake(j*30, i*30, 25, 21);
                imageView.image = [UIImage imageNamed:@"broker_property_house_no"];
                [_bucketContentView addSubview:imageView];
            }
        }
    }
    
    //推广按钮
    
}


- (void)startPromotion:(UIButton*)button{
    NSLog(@"立即推广");
    if (self.block != nil) {
        _block();
    }
    
}

@end
