//
//  AJKSaveMessModel.m
//  AnjukeBroker_New
//
//  Created by anjuke on 14-5-25.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AJKSaveMessModel.h"

@interface AJKSaveMessModel ()
{
}
@property (nonatomic, strong)NSString  *pd;//描述的文字

@end
@implementation AJKSaveMessModel

@synthesize fxa,fxo,pd,profid,sna,snc,st,stDa;

- (id)init
{
    self = [super init];
    if (self)
    {
        stDa = [NSDate date];
    }
    return self;
}

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
    [dict setValue:[NSString stringWithFormat:@"%@",pd] forKey:@"pd"];
    
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

- (NSString *)setPdString:(NSArray *)arr idArr:(NSArray *)idArr
{
    if (!arr || arr.count < idArr.count)
    {
        return @"";
    }
    
    NSMutableString *stw = [[NSMutableString alloc] init];
    int j = 0;
    if (idArr)
    {
        for (int i = 0; i < idArr.count; i++)
        {
            NSString *s = [NSString stringWithFormat:@"%@:%@", [idArr objectAtIndex:i],[arr objectAtIndex:i]];
            if (i == 0)
            {
                [stw appendString:s];
            }else
            {
                
                [stw appendFormat:@"(;;)%@", s];
            }
        }
        j = idArr.count;
    }
    
    for (; j < arr.count; j++)
    {
        NSString *s = [arr objectAtIndex:j];
        if (j == 0)
        {
            [stw appendString:s];
        }else
        {
            
            [stw appendFormat:@"(;;)%@", s];
        }
    }
    self.pd = stw;
    return stw;
}

- (NSString *)setPdString:(NSArray *)arr
{
    NSString *stw = [self setPdString:arr idArr:nil];
    return stw;
}

@end
