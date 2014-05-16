//
//  CheckCommunityModel.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-14.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckCommunityModel : NSObject

@property(nonatomic, strong) NSString *commId;
@property(nonatomic, strong) NSString *commName;
@property(nonatomic, assign) double lat;
@property(nonatomic, assign) double lng;
@property(nonatomic, assign) BOOL signAble;

+ (CheckCommunityModel *)convertToMappedObject:(NSDictionary *)dic;
@end
