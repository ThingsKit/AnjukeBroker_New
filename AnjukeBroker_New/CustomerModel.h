//
//  CustomerModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseModel.h"

@interface CustomerModel : BaseModel

//device_id: "123",
//user_name: "王女士",
//blcok_name: "塘桥",
//house_type_preference: "2室",
//price_preference: "150-200万",
//view_prop_num: "20",
//last_operate_time: "10分钟前",
//status: "1",
//status_msg: "抢完了"

@property (nonatomic, copy) NSString* device_id; //设备id
@property (nonatomic, copy) NSString* user_name;   //用户名
@property (nonatomic, copy) NSString* user_photo;  //用户头像
@property (nonatomic, copy) NSString* blcok_name; //地点
@property (nonatomic, copy) NSString* house_type_preference; //室
@property (nonatomic, copy) NSString* price_preference;  //价格或租金
@property (nonatomic, copy) NSString* view_prop_num; //浏览房源数
@property (nonatomic, copy) NSString* last_operate_time;  //用户上次登录时间
@property (nonatomic, copy) NSString* status; //当前改用户相对于经纪人的状态 (我抢了, 抢完了)
@property (nonatomic, copy) NSString* status_msg; //状态消息

@end
