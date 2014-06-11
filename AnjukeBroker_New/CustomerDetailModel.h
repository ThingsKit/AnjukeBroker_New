//
//  CustomerDetailModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseModel.h"

@interface CustomerDetailModel : BaseModel

@property (nonatomic, copy) NSString* userIcon; //用户头像路径
@property (nonatomic, copy) NSString* userName; //用户名称
@property (nonatomic, copy) NSString* propertyCount; //浏览房源数量

@property (nonatomic, copy) NSString* favoriteCommunity; //编号小区
@property (nonatomic, copy) NSString* favoriteHouseType; //偏好户型
@property (nonatomic, copy) NSString* favoritePrice; //偏好价格


@end
