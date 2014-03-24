//
//  NSString+AppendURLCommonParams.m
//  Anjuke2
//
//  Created by casa on 14-3-21.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "NSString+AppendURLCommonParams.h"
#import "AXMessageApiConfiguration.h"

@implementation NSString (AppendURLCommonParams)

- (NSString *)appendURLCommonParams
{
    UIDevice *device = [UIDevice currentDevice];
    
	NSString *m = [self defaultData:[device.model stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] defalut:@""];
	NSString *o = [self defaultData:[device.systemName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] defalut:@""];
    NSString *v = device.systemVersion;
	NSString *cv = [self defaultData:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] defalut:@""];
    NSString *pm = [[RTLogger sharedInstance] channelID];
    NSString *macid = [self defaultData:[device macaddressMD5] defalut:@""];
    NSString *uuid = [self defaultData:[device uuid] defalut:@""];
    NSString *from = @"mobile";
    NSString *ostype2 = [device ostype];
    NSString *udid2 = [self defaultData:[device udid] defalut:@""];
    NSString *uuid2 = [self defaultData:[device uuid] defalut:@""];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:NSLocalizedString(@"yyyyMMddHHmmss", nil)];
    NSString *qtime = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary *commonParams = @{
                                   @"cid" : udid2,
                                   @"ostype2" : ostype2,
                                   @"udid2" : udid2,
                                   @"uuid2" : uuid2,
                                   @"app" : kAXConnectManagerLinkAppName,
                                   @"cv" : cv,
                                   @"from" : from,
                                   @"m" : m,
                                   @"macid" : macid,
                                   @"o" : o,
                                   @"pm" : pm,
                                   @"qtime" : qtime,
                                   @"uuid" : uuid,
                                   @"v" : v
                                   };
    
    NSMutableString *finalParamString = [[NSMutableString alloc] initWithCapacity:0];
    [commonParams enumerateKeysAndObjectsWithOptions:0 usingBlock:^(id key, id obj, BOOL *stop) {
        if ([finalParamString length] == 0) {
            [finalParamString appendString:[NSString stringWithFormat:@"?%@=%@", key, obj]];
        } else {
            [finalParamString appendString:[NSString stringWithFormat:@"&%@=%@", key, obj]];
        }
    }];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self, finalParamString];
    return urlString;
}


#pragma mark - private method

- (id)defaultData:(id)data defalut:(id)defaultData {
    //如果获取的值与默认值的类型不同，直接返回默认值
    if (defaultData != nil && ![defaultData isKindOfClass:[data class]]) {
        if (![data isKindOfClass:[NSNull class]]) {
            //            DLog(@"data class dismatched: %@", [data class]);
            return defaultData;
        }
    }
    
    id temp = data;
    if ([self isNullData:data]) {
        temp = defaultData;
    }
    return temp;
}

- (BOOL)isNullData:(id)data{
    if ([data isEqual:[NSNull null]] || data == nil) {
        return YES;
    }
    return NO;
}
@end
