//
//  SalePropertyObject.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/6/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//
/*
 二手房房源对象
 
 装修:   decorate
 朝向:   orientation (单位：元， 未带）
 建造年代:   time (单位：套， 未带）
 */

#import "BasePropertyObject.h"

@interface SalePropertyObject : BasePropertyObject
@property (strong, nonatomic) NSString *decorate;
@property (strong, nonatomic) NSString *orientation;
@property (strong, nonatomic) NSString *time;

@end
