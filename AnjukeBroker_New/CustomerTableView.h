//
//  CustomerTableView.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseTableView.h"

@interface CustomerTableView : BaseTableView

@property (nonatomic, assign) int customerCount;  //一共有多少客户人数
@property (nonatomic, assign) int propertyRushableCount; //可抢房源数

@end
