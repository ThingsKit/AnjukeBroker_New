//
//  AXChatContentValidator.m
//  Anjuke2
//
//  Created by Gin on 3/4/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import "AXChatContentValidator.h"
#import "NSString+AXChatMessage.h"
#import "AXMappedMessage.h"

NSString * const AXChatJsonVersion = @"1";

@implementation AXChatContentValidator

- (BOOL)checkVersion:(NSDictionary *)data
{
    if (!data[@"jsonVersion"] ||
        ((data[@"jsonVersion"] || [data[@"jsonVersion"] isKindOfClass:[NSNumber class]]) &&
         (([data[@"jsonVersion"] isKindOfClass:[NSString class]] &&
           [data[@"jsonVersion"] isEqualToString:@"1"]) || ([data[@"jsonVersion"] integerValue] == 1 || [data[@"jsonVersion"] integerValue] == 0)))) {  // Android 经纪人有bug 如果等于0也给过了
            return YES;
        }
    return NO;
}

- (BOOL)checkText:(NSString *)content
{
    if ([self contentIsString:content] && [content length] > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)checkLocation:(NSString *)content
{
    NSDictionary *data = [content JSONValue];
    if (![self checkVersion:data]) {
        return NO;
    }
    
    if ((([self contentIsString:data[@"google_lat"]] && [self contentIsString:data[@"google_lng"]]) ||
         ([self contentIsString:data[@"baidu_lat"]] && [self contentIsString:data[@"baidu_lng"]])) &&
        [self contentIsString:data[@"address"]] &&
        [self contentIsString:data[@"from_map_type"]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)checkPropertyCard:(NSString *)content
{
    NSDictionary *data = [content JSONValue];
    if (![self checkVersion:data]) {
        return NO;
    }
    
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        if ([self contentIsString:data[@"des"]] &&
            [self contentIsString:data[@"img"]] &&
            [self contentIsString:data[@"name"]] &&
            [self contentIsString:data[@"price"]] &&
            [self contentIsString:data[@"url"]] &&
            data[@"tradeType"] &&
            ([data[@"tradeType"] integerValue] == AXMessagePropertySourceErShouFang ||
             [data[@"tradeType"] integerValue] == AXMessagePropertySourceZuFang ||
             [data[@"tradeType"] integerValue] == AXMessagePropertySourceCommunity ||
             [self checkIsJinpuCard:data[@"tradeType"]])) {
                return YES;
            }
    }
    return NO;
}

- (BOOL)checkPublicCard:(NSString *)content
{
    NSDictionary *data = [content JSONValue];
    if (![self checkVersion:data]) {
        return NO;
    }
    
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        if (data[@"title"] && data[@"date"] && data[@"img"] && data[@"desc"] && data[@"url"]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)checkPublicCard2:(NSString *)content
{
    NSDictionary *data = [content JSONValue];
    if (![self checkVersion:data]) {
        return NO;
    }
    
    if ([self contentIsString:data[@"title"]] && data[@"color"] &&
        data[@"props"] && [data[@"props"] isKindOfClass:[NSArray class]] && [data[@"props"] count] > 0) {
        for (NSDictionary *dict in data[@"props"]) {
            if (![dict isKindOfClass:[NSDictionary class]] || !dict[@"photo"] || ![self contentIsString:dict[@"photo"]] || ![self contentIsString:dict[@"text1"]]
                || ![self contentIsString:dict[@"text2"]] || ![self contentIsString:dict[@"text3"]] || ![self contentIsString:dict[@"text4"]]
                || !dict[@"icon"] || ![dict[@"icon"] isKindOfClass:[NSArray class]] || ![self contentIsString:dict[@"id"]] || ![self contentIsString:dict[@"cityid"]]
                || ![self contentIsString:dict[@"webview_url"]] || !dict[@"tradeType"]) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

- (BOOL)checkPublicCard3:(NSString *)content
{
    NSDictionary *data = [content JSONValue];
    if (![self checkVersion:data]) {
        return NO;
    }
    
    if (data[@"articles"] && [data[@"articles"] isKindOfClass:[NSArray class]] && [data[@"articles"] count] > 0) {
        BOOL flg = YES;
        for (NSDictionary *dict in data[@"articles"]) {
            if (dict && [dict isKindOfClass:[NSDictionary class]] && dict[@"title"] && dict[@"img"] && dict[@"tradeType"] && dict[@"url"] && dict[@"id"] && dict[@"cityid"]) {
                //
            } else {
                flg = NO;
            }
        }
        return flg;
    }
    return NO;
}

- (BOOL)checkVoice:(NSString *)content
{
    NSDictionary *data = [content JSONValue];
    if (![self checkVersion:data]) {
        return NO;
    }
    
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        // 以后添加版本区分
        if (data[@"length"]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)contentIsString:(id)content
{
    if (content && [content isKindOfClass:[NSString class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)checkIsJinpuCard:(NSNumber *)tradeType
{
    if (tradeType &&
        ([tradeType integerValue] == AXMessagePropertySourceShopRent ||
         [tradeType integerValue] == AXMessagePropertySourceShopBuy ||
         [tradeType integerValue] == AXMessagePropertySourceOfficeRent ||
         [tradeType integerValue] == AXMessagePropertySourceOfficeBuy)) {
            return YES;
        }
    return NO;
}

@end
