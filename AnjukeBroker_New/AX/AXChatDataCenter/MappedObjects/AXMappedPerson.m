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
    return [self initWithDictionary:dic isStranger:NO];
}

- (instancetype)initWithDictionary:(NSDictionary *)dic isStranger:(BOOL)isSt
{
    self = [super init];
    if (self) {
        self.uid = dic[@"user_id"];
        self.isStranger = isSt;
        self.created = [NSDate dateWithTimeIntervalSince1970:[dic[@"created"] integerValue]];
        self.isIconDownloaded = NO;
        self.lastActiveTime = [NSDate dateWithTimeIntervalSinceNow:0];
        self.lastUpdate = [NSDate dateWithTimeIntervalSinceNow:0];
        self.isStar = NO;
        if (!isSt)
        {
            self.markDesc = dic[@"desc"];
            self.iconUrl = dic[@"icon"];
            self.iconPath = @"";
            self.markName = dic[@"mark_name"];
            self.markNamePinyin = dic[@"mark_name_pinyin"]?dic[@"mark_name"]:@"";
            self.name = dic[@"nick_name"];
            self.namePinyin = dic[@"nick_name_pinyin"];
            self.phone = dic[@"phone"];
            self.userType = [dic[@"user_type"] integerValue];
            self.configs = dic[@"configs"];
            self.readMaxMsgId = @"0";
        }
        
        
    }
    return self;
}
@end
