//
//  FixedGroupObject.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/7/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleFixedGroupObject.h"

@implementation SaleFixedGroupObject
//@synthesize ceiling;
//@synthesize fee;
@synthesize groupId;
@synthesize planName;
@synthesize planStatus;
@synthesize propSize;
//@synthesize status;
@synthesize statusDescrip;
//@synthesize tradeType;
@synthesize userId;

- (id)setValueFromDictionary:(NSDictionary *)dic{    
    self.groupId = [dic objectForKey:@"groupId"];
    self.planName = [dic objectForKey:@"planName"];
    self.planStatus = [dic objectForKey:@"planStatus"];
    self.propSize = [dic objectForKey:@"propSize"];
    self.statusDescrip = [dic objectForKey:@"statusDescrip"];
    self.userId = [dic objectForKey:@"userId"];
    return self;
}
@end
