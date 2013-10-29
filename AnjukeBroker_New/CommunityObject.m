//
//  CommunityObject.m
//  ModelProject
//
//  Created by jianzhongliu on 10/25/13.
//  Copyright (c) 2013 anjuke. All rights reserved.
//

#import "CommunityObject.h"

@implementation CommunityObject
@synthesize communityId;
@synthesize communityArea;
@synthesize communityName;
@synthesize communityTime;

- (id)setValueFromDictionary:(NSDictionary *)dic{
    
    self.communityId = [dic objectForKey:@"communityId"];
    self.communityName = [dic objectForKey:@"communityName"];
    self.communityArea = [dic objectForKey:@"communityArea"];
    self.communityTime = [dic objectForKey:@"communityTime"];
    
    return self;
}

@end
