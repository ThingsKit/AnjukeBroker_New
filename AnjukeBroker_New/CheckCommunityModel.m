//
//  CheckCommunityModel.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-14.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CheckCommunityModel.h"

@implementation CheckCommunityModel
@synthesize commId;
@synthesize commName;
@synthesize lat;
@synthesize lng;
@synthesize signAble;


- (CheckCommunityModel *)convertToMappedObject:(NSDictionary *)dic{
    DLog(@"dicdic--->>%@",dic);
    CheckCommunityModel *model = [[CheckCommunityModel alloc] init];
    model.commId = [dic objectForKey:@"model"];
    model.commName = [dic objectForKey:@"commName"];
    model.lat = [[dic objectForKey:@"lat"] doubleValue];
    model.lng = [[dic objectForKey:@"lng"] doubleValue];
    model.signAble = [[dic objectForKey:@"signAble"] isEqualToString:@"0"] ? YES : NO;

    return model;

}
@end
