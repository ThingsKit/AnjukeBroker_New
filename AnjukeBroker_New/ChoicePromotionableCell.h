//
//  ChoicePromotionCell.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"

typedef void(^PromotionButtonBlock) (UIButton*); //返回类型void,  参数列表(void)

@class ChoicePromotionCellModel;
@interface ChoicePromotionableCell : RTListCell

@property (nonatomic, strong) ChoicePromotionCellModel* choicePromotionModel;
@property (nonatomic, copy) PromotionButtonBlock block;

@end
