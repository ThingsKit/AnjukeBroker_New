//
//  ChoicePromotionCellModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseModel.h"

@interface ChoicePromotionCellModel : BaseModel

@property (nonatomic, copy) NSString* totalClikcs; //总点击
@property (nonatomic, copy) NSString* balance;  //预算余额
@property (nonatomic, copy) NSString* balanceUnit; //预算余额单位
@property (nonatomic, copy) NSString* todayClicks; //今日点击
@property (nonatomic, copy) NSString* todayConsume; //今日花费
@property (nonatomic, copy) NSString* todayConsumeUnit; //今日花费单位
@property (nonatomic, copy) NSString* clickPrice; //点击单价
@property (nonatomic, copy) NSString* clickPriceUnit; //点击单价单位
@property (nonatomic, copy) NSString* maxBucketNum; //总共拥有坑位数
@property (nonatomic, copy) NSString* useNum; //已经使用坑位数
@property (nonatomic, copy) NSString* actionType; //排队还是推广 1-已推广 2-已排队 3-可推广 4-坑位已满


@end
