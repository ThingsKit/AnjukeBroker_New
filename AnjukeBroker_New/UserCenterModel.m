//
//  UserCenterModel.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-15.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "UserCenterModel.h"

@implementation UserCenterModel

@synthesize replyRate;
@synthesize responseTime;
@synthesize customNum;
@synthesize loginDays;
@synthesize isTalent;
@synthesize ajkContact;
@synthesize balance;
@synthesize tel;

- (UserCenterModel *)convertToMappedObject:(NSDictionary *)dic{
    UserCenterModel *model = [[UserCenterModel alloc] init];
    model.replyRate = [NSNumber numberWithInt:[[dic objectForKey:@"replyRate"] intValue]];
    model.responseTime = [NSNumber numberWithInt:[[dic objectForKey:@"responseTime"] intValue]];
    model.customNum = [NSNumber numberWithInt:[[dic objectForKey:@"customNum"] intValue]];
    model.loginDays = [NSNumber numberWithInt:[[dic objectForKey:@"loginDays"] intValue]];
    model.isTalent = [NSNumber numberWithInt:[[dic objectForKey:@"isTalent"] intValue]];
    model.ajkContact = [dic objectForKey:@"ajkContact"];
    model.balance = [NSNumber numberWithInt:[[dic objectForKey:@"balance"] intValue]];
    model.tel = [dic objectForKey:@"tel"];

    return model;
}
@end
