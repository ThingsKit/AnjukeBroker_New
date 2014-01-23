//
//  PublishDataModel.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Property.h"

@interface PublishDataModel : NSObject

+ (NSArray *)getPropertyTitleArrayForHaozu:(BOOL)isHZ;

//室
+ (NSMutableArray *)getPropertyHouseTypeArray_room;

+ (int)getRoomIndexWithValue:(NSString *)value;
+ (int)getRoomIndexWithTitle:(NSString *)title;
+ (NSString *)getRoomValueWithIndex:(int)index;
+ (NSString *)getRoomTitleWithIndex:(int)index;

//厅
+ (NSMutableArray *)getPropertyHouseTypeArray_hall;

+ (int)getHallIndexWithValue:(NSString *)value;
+ (NSString *)getHallTitleWithIndex:(int)index;

//卫
+ (NSMutableArray *)getPropertyHouseTypeArray_toilet;

+ (int)getToiletIndexWithValue:(NSString *)value;
+ (NSString *)getToiletTitleWithIndex:(int)index;

//楼
+ (NSMutableArray *)getPropertyFloor;

//层
+ (NSMutableArray *)getPropertyProFloor;

//装修
+ (NSArray *)getPropertyFitmentForHaozu:(BOOL)isHZ;

//朝向
+ (NSArray *)getPropertyExposure;

+ (int)getExposureIndexWithTitle:(NSString *)title;
+ (NSString *)getExposureTitleWithValue:(NSString *)value;

//出租方式
+ (NSArray *)getPropertyRentType;

//生成全新房源类
+ (Property *)getNewPropertyObject;

@end
