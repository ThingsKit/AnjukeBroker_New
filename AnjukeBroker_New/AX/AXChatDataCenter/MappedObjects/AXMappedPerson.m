//
//  AXMappedPerson.m
//  XCoreData
//
//  Created by casa on 14-2-18.
//  Copyright (c) 2014年 casa. All rights reserved.
//

#import "AXMappedPerson.h"

@implementation AXMappedPerson
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.created = [NSDate dateWithTimeIntervalSince1970:[dic[@"created"] integerValue]];
        self.iconUrl = dic[@"iconUrl"];
        self.iconPath = @"";
        self.isIconDownloaded = NO;
        self.lastActiveTime = [NSDate dateWithTimeIntervalSince1970:[dic[@"lastActiveTime"] integerValue]];
        self.lastUpdate = [NSDate dateWithTimeIntervalSinceNow:0];
        self.markName = dic[@"mark_name"]?dic[@"mark_name"]:@"";
        self.markNamePinyin = dic[@"mark_name_pinyin"]?dic[@"mark_name"]:@"";
        self.name = dic[@"nick_name"];
        self.namePinyin = dic[@"nick_name_pinyin"];
        self.phone = dic[@"phone"];
        self.uid = dic[@"user_id"];
        self.userType = [dic[@"user_type"] integerValue];
        self.isStar = NO;
    }
    return self;
}

@end
