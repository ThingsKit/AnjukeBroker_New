//
//  CustomerModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseModel.h"

@interface CustomerModel : BaseModel

@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* userIcon;  //用户头像
@property (nonatomic, copy) NSString* userName;   //用户名
@property (nonatomic, copy) NSString* loginTime;  //用户上次登录时间
@property (nonatomic, copy) NSString* location; //地点
@property (nonatomic, copy) NSString* room; //室
@property (nonatomic, copy) NSString* hall; //厅
@property (nonatomic, copy) NSString* toilet; //卫
@property (nonatomic, copy) NSString* area;   //面积
@property (nonatomic, copy) NSString* price;  //价格或租金
@property (nonatomic, copy) NSString* priceUnit;  //单位价格
@property (nonatomic, copy) NSString* propertyCount; //浏览房源数
@property (nonatomic, copy) NSString* userStatus; //当前改用户相对于经纪人的状态 (我抢了, 抢完了)

@end
