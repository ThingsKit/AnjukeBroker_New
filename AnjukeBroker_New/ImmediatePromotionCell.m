//
//  ImediatePromotionCell.m
//  AnjukeBroker_New
//
//  Created by jason on 7/2/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "ImmediatePromotionCell.h"
@interface ImmediatePromotionCell ()

@property(nonatomic)UIButton *promotionButton;
@property(nonatomic)UILabel  *priceLabel;

@end

@implementation ImmediatePromotionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellView];
    }
    return self;
}

- (void)initCellView
{
    UILabel *promotionLable   = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 305, 20)];
    promotionLable.text       = @"定价推广";
    promotionLable.font       = [UIFont systemFontOfSize:17];
    
    UILabel *priceLabel       = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 305, 15)];
    priceLabel.textColor      = [UIColor brokerLightGrayColor];
    priceLabel.font           = [UIFont systemFontOfSize:15];
    
    UIButton *promotionButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 65, 290, 42)];
    [promotionButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [promotionButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_press"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
    [promotionButton setTitle:@"立即推广" forState:UIControlStateNormal];
    
    self.promotionButton = promotionButton;
    self.priceLabel      = priceLabel;
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    [self addSubview:promotionLable];
    [self addSubview:priceLabel];
    [self addSubview:promotionButton];
}

- (void)layoutSubviews
{
    self.priceLabel.text = [NSString stringWithFormat:@"点击单价：%@%@",self.price,self.priceUnit];
}

- (void)addImediatePromotionButtonTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
   [self.promotionButton addTarget:target action:action forControlEvents:controlEvents];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
