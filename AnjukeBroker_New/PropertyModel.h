//
//  PropertyModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseModel.h"

@interface PropertyModel : BaseModel

@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* propertyId; //房源id
@property (nonatomic, copy) NSString* commName;  //小区名称
@property (nonatomic, copy) NSString* type;   //出售或出租
@property (nonatomic, copy) NSString* room;
@property (nonatomic, copy) NSString* hall;
@property (nonatomic, copy) NSString* toilet;
@property (nonatomic, copy) NSString* area;   //面积
@property (nonatomic, copy) NSString* price;  //价格或租金
@property (nonatomic, copy) NSString* priceUnit;  //单位价格
@property (nonatomic, copy) NSString* publishTime; //发布时间
@property (nonatomic, copy) NSString* status;
@property (nonatomic, copy) NSString* statusInfo;
@property (nonatomic, copy) NSString* ownerName;
@property (nonatomic, copy) NSString* ownerPhone;
@property (nonatomic, copy) NSString* callable;  //该房源是否可打电话
@property (nonatomic, copy) NSString* rushable;  //该房源是否可抢
@property (nonatomic, copy) NSString* rushed;  //该房源是否已经抢过了


@end
