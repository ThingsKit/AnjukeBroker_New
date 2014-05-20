//
//  PublishInputOrderModel.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

//发房row的顺序换算
//******二手房
#define AJK_TEXT_PRICE 0 //价格
//#define AJK_TEXT_LIMIT_PAY 1 //最低首付
#define AJK_TEXT_AREA 1 //面积
#define AJK_PICKER_ROOMS 2 //户型
#define AJK_PICKER_FLOORS 3 //楼层
#define AJK_PICKER_ORIENTATION 4 //朝向
#define AJK_PICKER_FITMENT 5 //装修
#define AJK_CLICK_FEATURE 6 //特色
#define AJK_CLICK_TITLE 7 //标题
#define AJK_CLICK_DESC 8 //房源详情
#define AJK_TEXT_SAFENUM 9 //备案号

//******租房
#define HZ_TEXT_PRICE 0 //价格
#define HZ_TEXT_AREA 1 //面积
#define HZ_CLICK_ROOMS 2 //户型
#define HZ_PICKER_FLOORS 3 //楼层
#define HZ_PICKER_ORIENTATION 4 //朝向
#define HZ_PICKER_FITMENT 5 //装修
#define HZ_PICKER_RENTTYPE 6 //出租方式
#define HZ_CLICK_TITLE 7 //标题
#define HZ_CLICK_DESC 8 //房源详情

@interface PublishInputOrderModel : NSObject

@end
