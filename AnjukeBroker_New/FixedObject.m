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
    
    self.fixedId = [dic objectForKey:@"fixedId"];
    self.tapNum = [dic objectForKey:@"tapNum"];
    self.cost = [dic objectForKey:@"cost"];
    self.totalCost = [dic objectForKey:@"totalCost"];
    self.topCost = [dic objectForKey:@"topCost"];
    self.fixedStatus = [dic objectForKey:@"fixedStatus"];
    self.totalProperty = [dic objectForKey:@"totalProperty"];
    
    return self;
}

@end
