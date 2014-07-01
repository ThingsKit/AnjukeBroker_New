//
//  PricePromotionCellModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseModel.h"

@interface PricePromotionCellModel : BaseModel

@property (nonatomic, copy) NSString* todayClicks;
@property (nonatomic, copy) NSString* totalClicks;
@property (nonatomic, copy) NSString* clickPrice;
@property (nonatomic, copy) NSString* clickPriceUnit;


@end
