//
//  PropertyDataManager.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Property.h"

@interface PropertyDataManager : NSObject

+ (NSArray *)getPropertyTitleArrayForHaozu:(BOOL)isHZ;

//户型——室、厅、卫
+ (NSMutableArray *)getPropertyHuxingArray_Shi;
+ (NSMutableArray *)getPropertyHuxingArray_Ting;
+ (NSMutableArray *)getPropertyHuxingArray_Wei;

//装修情况
+ (NSArray *)getPropertyFitmentForHaozu:(BOOL)isHZ;

//朝向
+ (NSArray *)getPropertyChaoXiang;

//楼层
+ (NSMutableArray *)getPropertyLou_Number;
+ (NSMutableArray *)getPropertyCeng_Number;

//整租方式_仅租房
+ (NSArray *)getPropertyRentType;

//生成全新房源类
+ (Property *)getNewPropertyObject;

@end
