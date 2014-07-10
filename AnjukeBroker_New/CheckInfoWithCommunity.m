//
//  CheckInfoWithCommunity.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-14.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "CheckInfoWithCommunity.h"

@implementation CheckInfoWithCommunity

@synthesize countDown;
@synthesize signAble;
@synthesize signCount;
@synthesize signList;

+ (CheckInfoWithCommunity *)convertToMappedObject:(NSDictionary *)dic{
    CheckInfoWithCommunity *model = [[CheckInfoWithCommunity alloc] init];
    model.countDown = [dic objectForKey:@"countDown"];
    model.signAble = [dic objectForKey:@"signAble"];
    model.signCount = [dic objectForKey:@"signCount"];
    model.signList = [dic objectForKey:@"signList"];
    
    return model;
}
@end
