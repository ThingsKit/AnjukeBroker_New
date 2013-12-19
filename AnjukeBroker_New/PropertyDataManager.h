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

+ (int)getRoomIndexWithNum:(NSString *)num; //室厅卫所在数据库位置
+ (int)getHallIndexWithNum:(NSString *)num;
+ (int)getToiletIndexWithNum:(NSString *)num;

+ (int)getRoomIndexWithTitle:(NSString *)title;

//装修情况
+ (NSArray *)getPropertyFitmentForHaozu:(BOOL)isHZ;

+ (int)getFitmentIndexWithString:(NSString *)string forHaozu:(BOOL)isHaozu;
+ (NSString *)getFitmentTitleWithNum:(NSString *)num forHaozu:(BOOL)isHaozu;
+ (NSString *)getFitmentVauleWithTitle:(NSString *)title forHaozu:(BOOL)isHaozu;

//朝向
+ (NSArray *)getPropertyChaoXiang;

+ (int)getExposureIndexWithTitle:(NSString *)title;
//+ (NSString *)getExposureTitleWithNum:(NSString *)num; //仅租房用
+ (NSString *)getExposureValueWithTitle:(NSString *)title;

//楼层
+ (NSMutableArray *)getPropertyLou_Number;
+ (NSMutableArray *)getPropertyCeng_Number;

+ (int)getProFloorIndexWithNum:(NSString *)num;
+ (int)getFloorIndexWithNum:(NSString *)num;

+ (int)getFloorIndexWithTitle:(NSString *)title;
+ (int)getProFloorIndexWithTitle:(NSString *)title;

//整租方式_仅租房
+ (NSArray *)getPropertyRentType;

+ (NSString *)getRentTypeTitleWithNum:(NSString *)num;
+ (int)getRentTypeIndexWithNum:(NSString *)num;

//生成全新房源类
+ (Property *)getNewPropertyObject;

@end
