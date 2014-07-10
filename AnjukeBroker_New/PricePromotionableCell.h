//
//  PricePromotionableCell.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-2.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"

typedef void(^PromotionButtonBlock) (UIButton*); //返回类型void,  参数列表(void)

@class PricePromotionCellModel;
@interface PricePromotionableCell : RTListCell

@property (nonatomic, strong) PricePromotionCellModel* pricePromotionCellModel;
@property (nonatomic, copy) PromotionButtonBlock block;

@end
