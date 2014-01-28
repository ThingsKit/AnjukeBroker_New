//
//  PublishDataModel.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Property.h"

//发房预设值
#define _DEFULT_TITLE_FITMENT @"精装修"
#define _DEFULT_TITLE_EXPOSURE @"南北"
#define _DEFULT_VALUE_FLOOR @"3"
#define _DEFULT_VALUE_PROFLOOR @"6"

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

+ (int)getFloorIndexWithValue:(NSString *)value;
+ (int)getFloorIndexWithTitle:(NSString *)title;
+ (NSString *)getFloorValueWithIndex:(int)index;

//层
+ (NSMutableArray *)getPropertyProFloor;

+ (int)getProFloorIndexWithTitle:(NSString *)title;
+ (int)getProFloorIndexWithValue:(NSString *)value;

//装修
+ (NSArray *)getPropertyFitmentForHaozu:(BOOL)isHZ;

+ (int)getFitmentIndexWithTitle:(NSString *)title forHaozu:(BOOL)isHaozu;
+ (NSString *)getFitmentTitleWithValue:(NSString *)value forHaozu:(BOOL)isHaozu;
+ (NSString *)getFitmentVauleWithTitle:(NSString *)title forHaozu:(BOOL)isHaozu;

//朝向
+ (NSArray *)getPropertyExposure;

+ (int)getExposureIndexWithTitle:(NSString *)title;
+ (NSString *)getExposureTitleWithValue:(NSString *)value;

//出租方式
+ (NSArray *)getPropertyRentType;

//生成全新房源类
+ (Property *)getNewPropertyObject;

@end
