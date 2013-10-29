//
//  CommunityObject.h
//  ModelProject
//
//  Created by jianzhongliu on 10/25/13.
//  Copyright (c) 2013 anjuke. All rights reserved.
//
/**
小区编号: communityId
小区名称: communityName
小区地址: communityArea
小区竣工时间: communityTime
 **/

#import <Foundation/Foundation.h>

@interface CommunityObject : NSObject
@property (strong, nonatomic) NSString *communityId;
@property (strong, nonatomic) NSString *communityName;
@property (strong, nonatomic) NSString *communityArea;
@property (strong, nonatomic) NSString *communityTime;

- (id)setValueFromDictionary:(NSDictionary *)dic;

@end
