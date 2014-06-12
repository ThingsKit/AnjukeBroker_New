//
//  FavoritePropertyModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseModel.h"

@interface FavoritePropertyModel : BaseModel

@property (nonatomic, copy) NSString* propertyId; //房源id
@property (nonatomic, copy) NSString* propertyIcon; //房源图片
@property (nonatomic, copy) NSString* propertyTitle;  //房源标题
@property (nonatomic, copy) NSString* location;   //房源所属板块
@property (nonatomic, copy) NSString* community; //房源所属小区
@property (nonatomic, copy) NSString* room; //室
@property (nonatomic, copy) NSString* hall; //厅
@property (nonatomic, copy) NSString* toilet; //卫
@property (nonatomic, copy) NSString* area;   //面积
@property (nonatomic, copy) NSString* price;  //价格或租金
@property (nonatomic, copy) NSString* priceUnit;  //单位价格

@end
