//
//  ChoicePromotionCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//
#define GAP_HORIZONTAL 15
#define GAP_VERTICAL 14

#import "ChoicePromotionableCell.h"
#import "ChoicePromotionCellModel.h"

@interface ChoicePromotionableCell ()

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

@implementation ChoicePromotionableCell

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
    _promotionStatus.frame = CGRectMake(20, _title.bottom + GAP_VERTICAL - 5, 100, 20);
    if ([@"3" isEqualToString:self.choicePromotionModel.actionType]) { //可推广
        _promotionStatus.text = @"可立即推广";
        [_promotionStatus sizeToFit];
    }
    
    //点击单价
    _unitNumber.frame = CGRectMake(_promotionStatus.right + GAP_HORIZONTAL, _title.bottom + GAP_VERTICAL -5, 100, 20);
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
    int total = [self.choicePromotionModel.maxBucketNum intValue];
    int used = [self.choicePromotionModel.useNum intValue];
    int row = 2;
    int column = 0;
    int houseGapHorizontal = 0;
    int houseGapVertical = 0;
    int houseWidth = 0;
    int houseHeight = 0;
    
    if (total == 12) { //如果是 6 列
        column = 6;
        houseGapHorizontal = 30*1.2;
        houseGapVertical = 32;
        houseWidth = 25;
        houseHeight = 21;
        _bucketContentView.frame = CGRectMake(_promotionVacancy.right + GAP_HORIZONTAL, _unitNumber.bottom + GAP_VERTICAL - 4, 200, 60);
    }else if(total == 20){  //如果是 10 列
        column = 10;
        houseGapHorizontal = 30*0.76;
        houseGapVertical = 30*1.1;
        houseWidth = 19;
        houseHeight = 16;
        _bucketContentView.frame = CGRectMake(_promotionVacancy.right + GAP_HORIZONTAL, _unitNumber.bottom + GAP_VERTICAL, 200, 60);
    }else{
        NSLog(@"---------------  %d 坑位总数异常", total);
        return;
    }
    
    
    
    for (int i = 0; i < total; i++) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, houseWidth, houseHeight)];
        [_buckets addObject:imageView];
    }
    
    
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < column; j++) {
            if ((i*column + j) < used) {
                UIImageView* imageView = [_buckets objectAtIndex:(i*column + j)];
                imageView.frame = CGRectMake(j*houseGapHorizontal, i*houseGapVertical, houseWidth, houseHeight);
                imageView.image = [UIImage imageNamed:@"broker_property_house_blue"];
                [_bucketContentView addSubview:imageView];
                
            }else if((i*column + j) == used){
                UIImageView* imageView = [_buckets objectAtIndex:(i*column + j)];
                imageView.frame = CGRectMake(j*houseGapHorizontal, i*houseGapVertical, houseWidth, houseHeight);
                imageView.image = [UIImage imageNamed:@"broker_property_house_now"];
                [_bucketContentView addSubview:imageView];
                
                if (column == 6) {
                    _cursor = [[UIImageView alloc] initWithFrame:CGRectMake(j*houseGapHorizontal + 8, i*houseGapVertical + 23, 10, 5)];
                }else{
                    _cursor = [[UIImageView alloc] initWithFrame:CGRectMake(j*houseGapHorizontal + 5, i*houseGapVertical + 18, 10, 5)];
                }
                _cursor.image = [UIImage imageNamed:@"broker_property_house_arrow"];
                [_bucketContentView addSubview:_cursor];
                
            }else{
                UIImageView* imageView = [_buckets objectAtIndex:(i*column + j)];
                imageView.frame = CGRectMake(j*houseGapHorizontal, i*houseGapVertical, houseWidth, houseHeight);
                imageView.image = [UIImage imageNamed:@"broker_property_house_no"];
                [_bucketContentView addSubview:imageView];
            }
        }
    }
    
    //推广按钮
    _promotionButton.frame = CGRectMake(15, _queueVacancy.bottom + GAP_VERTICAL + 2, ScreenWidth-15*2, 42);
    if (used == total) {
        [_promotionButton setTitle:@"推广位已满" forState:UIControlStateNormal];
        [_promotionButton setTitleColor:[UIColor brokerLightGrayColor] forState:UIControlStateNormal];
        _promotionButton.titleLabel.font = [UIFont ajkH2Font];
        
        [_promotionButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_gray_hollow"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateNormal];
        _promotionButton.enabled = NO;
        
    }else if(used >= total*0.5){
        
        [_promotionButton setTitle:@"立即排队" forState:UIControlStateNormal];
        _promotionButton.titleLabel.font = [UIFont ajkH2Font];
        [_promotionButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateNormal];
        [_promotionButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_press"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateHighlighted];
        _promotionButton.tag = 10;
        _promotionButton.enabled = YES;
        
    }else{
        [_promotionButton setTitle:@"立即推广" forState:UIControlStateNormal];
        _promotionButton.titleLabel.font = [UIFont ajkH2Font];
        [_promotionButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateNormal];
        [_promotionButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_press"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateHighlighted];
        _promotionButton.tag = 20;
        _promotionButton.enabled = YES;
    }
    
}


- (void)startPromotion:(UIButton*)button{
    NSLog(@"立即推广");
    if (self.block != nil) {
        _block(); //这个tag用来标示是立即排队 还是 立即推广
    }
    
}

@end
