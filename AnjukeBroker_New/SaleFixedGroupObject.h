//
//  FixedGroupObject.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/7/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 定价组对象
 
 限额:   ceiling
 花费:   fee
 定价组:   groupId
 定价组名称:   planName
 定价组计划状态:   planStatus
 定价组房源数:   propSize
 :   status
 状态描述:   statusDescrip
 :   tradeType
 经纪人编号:   userId
 */
@interface SaleFixedGroupObject : NSObject
//@property (strong, nonatomic) NSString *ceiling;
//@property (strong, nonatomic) NSString *fee;
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *planName;
@property (strong, nonatomic) NSString *planStatus;
@property (strong, nonatomic) NSString *propSize;
//@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *statusDescrip;
//@property (strong, nonatomic) NSString *tradeType;
@property (strong, nonatomic) NSString *userId;

- (id)setValueFromDictionary:(NSDictionary *)dic;

@end
