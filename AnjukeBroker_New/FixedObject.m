//
//  FixedObject.m
//  ModelProject
//
//  Created by jianzhongliu on 10/25/13.
//  Copyright (c) 2013 anjuke. All rights reserved.
//

#import "FixedObject.h"

@implementation FixedObject
@synthesize fixedId;
@synthesize planName;
@synthesize tapNum;
@synthesize cost;
@synthesize totalCost;
@synthesize topCost;
@synthesize fixedStatus;
@synthesize totalProperty;

- (id)setValueFromDictionary:(NSDictionary *)dic{
    
    self.fixedId = [dic objectForKey:@"fixPlanId"];
    self.planName = [dic objectForKey:@"fixPlanName"];
    self.tapNum = [dic objectForKey:@"fixPlanClickNum"];
    self.cost = [dic objectForKey:@"fixPlanCosts"];
//    self.totalCost = [dic objectForKey:@"totalCost"];
    self.topCost = [dic objectForKey:@"fixPlanPropCeiling"];
    self.fixedStatus = [dic objectForKey:@"fixPlanState"];
//    self.totalProperty = [dic objectForKey:@"totalProperty"];
    
    return self;
}

@end
