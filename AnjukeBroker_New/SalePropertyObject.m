//
//  SalePropertyObject.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/6/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SalePropertyObject.h"

@implementation SalePropertyObject
@synthesize time;
@synthesize decorate;
@synthesize orientation;

- (id)setValueFromDictionary:(NSDictionary *)dic{
    [super setValueFromDictionary:dic];
    
    self.time = [dic objectForKey:@"time"];
    self.decorate = [dic objectForKey:@"decorate"];
    self.orientation = [dic objectForKey:@"orientation"];
    
    return self;
}
@end
