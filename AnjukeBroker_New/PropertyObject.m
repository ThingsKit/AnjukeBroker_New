//
//  PropertyObject.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "PropertyObject.h"

@implementation PropertyObject
@synthesize propertyId;
@synthesize price;
@synthesize communityName;
@synthesize title;

- (id)setValueFromDictionary:(NSDictionary *)dic{
    
    self.propertyId = [dic objectForKey:@"propertyId"];
    self.price = [dic objectForKey:@"price"];
    self.communityName = [dic objectForKey:@"communityName"];
    self.title = [dic objectForKey:@"title"];
    
    return self;
}

@end
