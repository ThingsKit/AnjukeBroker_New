//
//  ChoiceSummaryModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-3.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseModel.h"

@interface ChoiceSummaryModel : BaseModel

@property (nonatomic, copy) NSString* todayClicks;
@property (nonatomic, copy) NSString* todayConsume;
@property (nonatomic, copy) NSString* consumeUnit;
@property (nonatomic, copy) NSString* minChoicePrice;
@property (nonatomic, copy) NSString* minChoicePriceUnit;
@property (nonatomic, copy) NSString* maxChoicePrice;
@property (nonatomic, copy) NSString* maxChoicePriceUnit;
@property (nonatomic, copy) NSString* propNum;

@end
