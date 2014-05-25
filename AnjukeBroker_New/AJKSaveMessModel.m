//
//  AJKSaveMessModel.m
//  AnjukeBroker_New
//
//  Created by anjuke on 14-5-25.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AJKSaveMessModel.h"


@implementation AJKSaveMessModel

@synthesize fxa,fxo,pd,profid,sna,snc,st,stDa;

- (NSString *)st
{
    if (!st || st.length == 0)
    {
        NSDateFormatter *dateFormatrer = [[NSDateFormatter alloc] init];
        dateFormatrer.dateFormat = @"yyyy-mm-dd HH:mm:ss";
        
        return [dateFormatrer stringFromDate:stDa];
    }
    
    return st;
}

- (NSDictionary *)objectToDict
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:st forKey:@"st"];
    [dict setValue:profid forKey:@"propid"];
    [dict setValue:[NSString stringWithFormat:@"%d",sna] forKey:@"sna"];
    [dict setValue:[NSString stringWithFormat:@"%d",snc] forKey:@"snc"];
    [dict setValue:[NSString stringWithFormat:@"%d",fxa] forKey:@"fxa"];
    [dict setValue:[NSString stringWithFormat:@"%d",fxo] forKey:@"fxo"];
    [dict setValue:[NSString stringWithFormat:@"%d",pd] forKey:@"pd"];
    
    return dict;
}

- (NSString *)objToJson
{
    NSDictionary *dict = [self objectToDict];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

@end
