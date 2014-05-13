//
//  PropertyModel.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PropertyModel.h"

@implementation PropertyModel

//{"status":"ok"，"data":{"name":"小区名称","type":"租售状态(1:出租 2:出售)","rooms":"房型","area":"面积","price":"151222222","phone":"151222222","time":"发布时间"}}

- (void)setAttributes:(NSDictionary *)dataDic {
    [super setAttributes:dataDic];
    
    NSDictionary* communityDic = [dataDic objectForKey:@"data"];
    
    CommunityModel* community = [[CommunityModel alloc] initWithDataDic:communityDic];
    self.community = community;
    
}

@end
