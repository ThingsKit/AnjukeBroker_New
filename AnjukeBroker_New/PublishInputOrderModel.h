//
//  PublishInputOrderModel.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

//发房row的顺序换算
#define AJK_TEXT_PRICE 0 //价格
#define AJK_TEXT_AREA 1 //面积
#define AJK_CLICK_ROOMS 2 //房型
#define AJK_PICKER_FLOORS 3 //楼层
#define AJK_PICKER_FITMENT 4 //装修
#define AJK_CLICK_TITLE 5 //标题
#define AJK_CLICK_DESC 6 //房源详情

#define HZ_TEXT_PRICE 0 //价格
#define HZ_TEXT_AREA 1 //面积
#define HZ_CLICK_ROOMS 2 //房型
#define HZ_PICKER_FLOORS 3 //楼层
#define HZ_PICKER_FITMENT 4 //装修
#define HZ_PICKER_RENTTYPE 5 //出租方式
#define HZ_CLICK_TITLE 6 //标题
#define HZ_CLICK_DESC 7 //房源详情

@interface PublishInputOrderModel : NSObject

@end
