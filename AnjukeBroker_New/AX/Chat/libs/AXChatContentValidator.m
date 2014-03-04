//
//  AXChatContentValidator.m
//  Anjuke2
//
//  Created by Gin on 3/4/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import "AXChatContentValidator.h"
#import "NSString+AXChatMessage.h"

@implementation AXChatContentValidator

- (BOOL)checkPropertyCard:(NSString *)content
{
    NSDictionary *data = [content JSONValue];
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        // 以后添加版本区分
        if (data[@"des"] && data[@"img"] && data[@"name"] && data[@"price"] && data[@"url"] && data[@"tradeType"]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)checkPublicCard:(NSString *)content
{
    NSDictionary *data = [content JSONValue];
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        // 以后添加版本区分
        if (data[@"title"] && data[@"date"] && data[@"img"] && data[@"desc"] && data[@"url"]) {
            return YES;
        }
    }
    return NO;
}

@end
