//
//  HouseSendModel.m
//  AnjukeBroker_New
//
//  Created by anjuke on 14-6-25.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "HouseSendModel.h"

@implementation HouseSendModel


- (NSDictionary *)objToDict
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setValue:self.price forKey:@"price"];
    [dict setValue:self.img forKey:@"img"];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.tradeType forKey:@"tradeType"];
    [dict setValue:self.des forKey:@"des"];
    [dict setValue:self.url forKey:@"url"];
    return dict;
}
@end
