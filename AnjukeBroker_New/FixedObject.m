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
@synthesize tapNum;
@synthesize cost;
@synthesize totalCost;
@synthesize topCost;
@synthesize fixedStatus;
@synthesize totalProperty;

- (id)setValueFromDictionary:(NSDictionary *)dic{
    
    self.fixedId = [dic objectForKey:@"id"];
    self.tapNum = [dic objectForKey:@"cnum"];
    self.cost = [dic objectForKey:@"fee"];
//    self.totalCost = [dic objectForKey:@"totalCost"];
    self.topCost = [dic objectForKey:@"ceiling"];
    self.fixedStatus = [dic objectForKey:@"planStatus"];
//    self.totalProperty = [dic objectForKey:@"totalProperty"];
    
    return self;
}

@end
