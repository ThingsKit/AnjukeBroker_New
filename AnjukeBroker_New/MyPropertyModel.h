//
//  MyPropertyModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-14.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "BaseModel.h"

@interface MyPropertyModel : BaseModel

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
@property (nonatomic, copy) NSString* status;  //状态
@property (nonatomic, copy) NSString* statusInfo;  //状态文字描述
@property (nonatomic, copy) NSString* publishTime; //发布时间
@property (nonatomic, copy) NSString* callable;  //该房源是否可拨打电话
@property (nonatomic, copy) NSString* ownerName;  //房东名字
@property (nonatomic, copy) NSString* ownerPhone; //房东电话

@end
