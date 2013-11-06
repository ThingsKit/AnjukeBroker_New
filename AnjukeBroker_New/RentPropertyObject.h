//
//  RentPropertyObject.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/6/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//
/*
 二手房房源对象
 
 出租方式:   rentType
 付款方式:   payType 
 */
#import "BasePropertyObject.h"

@interface RentPropertyObject : BasePropertyObject
@property (strong, nonatomic) NSString *rentType;
@property (strong, nonatomic) NSString *payType;

@end
