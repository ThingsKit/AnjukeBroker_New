//
//  InputOrderManager.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-22.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

//picker所在row
#define AJK_P_ROOMS 1 //户型row
#define AJK_P_FITMENT 4 //装修
#define AJK_P_EXPOSURE 5 //朝向
#define AJK_P_FLOORS 6 //楼层

#define HZ_P_ROOMS 1
#define HZ_P_RENTTYPE 4 //出租方式
#define HZ_P_FITMENT 5 //装修
#define HZ_P_EXPOSURE 6 //朝向
#define HZ_P_FLOORS 7 //楼层

//textField所在row
#define AJK_T_AREA 2
#define AJK_T_PRICE 3
#define AJK_T_TITLE 7 //标题
#define AJK_T_DESC 8 //房源详情

#define HZ_T_AREA 2
#define HZ_T_PRICE 3
#define HZ_T_TITLE 8 //标题
#define HZ_T_DESC 9 //房源详情

@interface InputOrderManager : NSObject

+ (BOOL)isKeyBoardInputWithIndex:(int)index isHaozu:(BOOL)isHZ;
+ (BOOL)isSegmentCellStyle:(int)index isHaozu:(BOOL)isHZ;

@end
