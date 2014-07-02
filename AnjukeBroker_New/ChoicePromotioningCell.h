//
//  ChoicePromotioningCell.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-2.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

typedef void(^PromotionButtonBlock) (void); //返回类型void,  参数列表(void)

@class ChoicePromotionCellModel;
@interface ChoicePromotioningCell : RTListCell

@property (nonatomic, strong) ChoicePromotionCellModel* choicePromotionModel;
@property (nonatomic, copy) PromotionButtonBlock block;

@end
