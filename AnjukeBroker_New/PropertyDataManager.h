//
//  PropertyDataManager.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyDataManager : NSObject

+ (NSArray *)getPropertyTitleArrayForAnjuke:(BOOL)isAnjuke;

//户型——室、厅、卫
+ (NSMutableArray *)getPropertyHuxingArray_Shi;
+ (NSMutableArray *)getPropertyHuxingArray_Ting;
+ (NSMutableArray *)getPropertyHuxingArray_Wei;

//装修情况
+ (NSArray *)getPropertyZhuangxiu;

//朝向
+ (NSArray *)getPropertyChaoXiang;

//楼层
+ (NSMutableArray *)getPropertyLou_Number;
+ (NSMutableArray *)getPropertyCeng_Number;

@end
