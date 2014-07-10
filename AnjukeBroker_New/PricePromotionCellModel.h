//
//  PricePromotionCellModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "BaseModel.h"

@interface PricePromotionCellModel : BaseModel

@property (nonatomic, copy) NSString* planId; //定价计划ID
@property (nonatomic, copy) NSString* todayClicks; //今日点击
@property (nonatomic, copy) NSString* totalClicks; //总点击
@property (nonatomic, copy) NSString* clickPrice; //点击单价
@property (nonatomic, copy) NSString* clickPriceUnit;


@end
