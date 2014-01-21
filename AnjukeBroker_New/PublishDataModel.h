//
//  PublishDataModel.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishDataModel : NSObject

+ (NSArray *)getPropertyTitleArrayForHaozu:(BOOL)isHZ;

//室
+ (NSMutableArray *)getPropertyHouseTypeArray_room;

//厅
+ (NSMutableArray *)getPropertyHouseTypeArray_hall;

//楼
+ (NSMutableArray *)getPropertyFloor;

//层
+ (NSMutableArray *)getPropertyProFloor;

//装修
+ (NSArray *)getPropertyFitmentForHaozu:(BOOL)isHZ;

@end
