//
//  UserCenterModel.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-15.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCenterModel : NSObject

@property(nonatomic, assign) NSNumber *replyRate;
@property(nonatomic, assign) NSNumber *responseTime;
@property(nonatomic, assign) NSNumber *customNum;
@property(nonatomic, assign) NSNumber *loginDays;
@property(nonatomic, assign) NSNumber *isTalent;
@property(nonatomic, strong) NSString *ajkContact;
@property(nonatomic, assign) NSNumber *balance;
@property(nonatomic, strong) NSString *tel;

+ (UserCenterModel *)convertToMappedObject:(NSDictionary *)dic;
@end
