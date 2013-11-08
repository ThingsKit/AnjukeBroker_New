//
//  FixedObject.h
//  ModelProject
//
//  Created by jianzhongliu on 10/25/13.
//  Copyright (c) 2013 anjuke. All rights reserved.
//
/*
 定价推广计划对象
 
 定价组编号:    fixedId
 总点击量:   tapNum
 今日花费:   cost (单位：元， 未带）
 总花费:   totalCost (单位：套， 未带）
 每日限额:   topCost (单位：元， 未带）
 计划状态:   fixedStatus    1:推广中 3：已停止
 房源总套数:   totalProperty
 
 */

#import <Foundation/Foundation.h>

@interface FixedObject : NSObject
@property (strong, nonatomic) NSString *fixedId;
@property (strong, nonatomic) NSString *tapNum;
@property (strong, nonatomic) NSString *cost;
@property (strong, nonatomic) NSString *totalCost;
@property (strong, nonatomic) NSString *topCost;
@property (strong, nonatomic) NSString *fixedStatus;
@property (strong, nonatomic) NSString *totalProperty;

- (id)setValueFromDictionary:(NSDictionary *)dic;

@end
