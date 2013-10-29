//
//  PropertyObject.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 定价推广计划对象
 
 房源编号:    propertyId
 房源标题:   title
 小区名:   communityName
 房子价格:   price (单位：元， 未带）

 
 */

@interface PropertyObject : NSObject
@property (strong, nonatomic) NSString *propertyId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *communityName;
@property (strong, nonatomic) NSString *price;

- (id)setValueFromDictionary:(NSDictionary *)dic;

@end
