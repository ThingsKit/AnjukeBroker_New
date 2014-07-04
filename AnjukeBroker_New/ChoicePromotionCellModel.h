//
//  ChoicePromotionCellModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseModel.h"

@interface ChoicePromotionCellModel : BaseModel

@property (nonatomic, copy) NSString* totalClicks; //总点击
@property (nonatomic, copy) NSString* balance;  //预算余额
@property (nonatomic, copy) NSString* balanceUnit; //预算余额单位
@property (nonatomic, copy) NSString* todayClicks; //今日点击
@property (nonatomic, copy) NSString* todayConsume; //今日花费
@property (nonatomic, copy) NSString* todayConsumeUnit; //今日花费单位
@property (nonatomic, copy) NSString* clickPrice; //点击单价
@property (nonatomic, copy) NSString* clickPriceUnit; //点击单价单位
@property (nonatomic, copy) NSString* maxBucketNum; //总共拥有坑位数
@property (nonatomic, copy) NSString* usedBucketNum; //已经使用坑位数
@property (nonatomic, copy) NSString* status; //排队还是推广 //1-1 推广中 1-2排队中 2-1推广位已满 2-2可立即排队 2-3可立即推广 3-2不符合精选推广条件
@property (nonatomic, copy) NSString* statusMsg; //状态对应的消息描述


@end
