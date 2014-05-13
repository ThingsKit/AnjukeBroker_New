//
//  CommunityModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseModel.h"

//{"status":"ok"，"data":{"name":"小区名称","type":"租售状态(1:出租 2:出售)","rooms":"房型","area":"面积","price":"151222222","phone":"151222222","time":"发布时间"}}

@interface CommunityModel : BaseModel

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* type;
@property (nonatomic, copy) NSString* rooms;
@property (nonatomic, copy) NSString* area;
@property (nonatomic, copy) NSString* price;
@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* time;

@end
