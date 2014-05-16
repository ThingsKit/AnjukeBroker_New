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

+ (UserCenterModel *)convertToMappedObject:(NSDictionary *)dic{
    UserCenterModel *model = [[UserCenterModel alloc] init];
    model.replyRate = [dic objectForKey:@"replyRate"];
    model.responseTime = [dic objectForKey:@"responseTime"];
    model.customNum = [dic objectForKey:@"customNum"];
    model.loginDays = [dic objectForKey:@"loginDays"];
    model.isTalent = [dic objectForKey:@"isTalent"] ;
    model.ajkContact = [dic objectForKey:@"ajkContact"];
    model.balance = [dic objectForKey:@"balance"];
    model.tel = [dic objectForKey:@"tel"];

    return model;
}
@end
