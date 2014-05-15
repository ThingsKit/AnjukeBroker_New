//
//  CheckInfoWithCommunity.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-14.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CheckInfoWithCommunity.h"

@implementation CheckInfoWithCommunity

@synthesize countDown;
@synthesize signAble;
@synthesize signCount;
@synthesize signList;

- (CheckInfoWithCommunity *)convertToMappedObject:(NSDictionary *)dic{
    CheckInfoWithCommunity *model = [[CheckInfoWithCommunity alloc] init];
    model.countDown = [NSNumber numberWithInt:[[dic objectForKey:@"countDown"] intValue]];
    model.signAble = [NSNumber numberWithInt:[[dic objectForKey:@"signAble"] intValue]];
    model.signCount = [NSNumber numberWithInt:[[dic objectForKey:@"signCount"] intValue]];
    model.signList = [dic objectForKey:@"signList"];
    
    return model;
}
@end
