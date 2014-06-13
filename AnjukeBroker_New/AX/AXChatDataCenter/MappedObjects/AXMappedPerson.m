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
        /*
         corp = anjuke;
         desc = "";
         gender = female;
         "has_password" = 0;
         icon = "http://pic1.ajkimg.com/display/origin/4c5b0b640c8fa2477020977d0165ca06/120x120.jpg";
         "is_active" = 0;
         "is_star" = 0;
         "last_update" = "2014-03-03 18:00:08";
         "mark_desc" = "";
         "mark_name" = "";
         "mark_name_pinyin" = "";
         "mark_phone" = "";
         "nick_name" = "\U98de\U98de\U7ecf\U7eaa\U4eba";
         "nick_name_pinyin" = "fei fei jing ji ren";
         phone = 13400000088;
         "relation_cate_id" = 0;
         "relation_cate_name" = default;
         "two_code_icon" = "";
         "user_id" = 2000000073;
         "user_type" = 1;
         */
        self.created = [NSDate dateWithTimeIntervalSince1970:[dic[@"created"] integerValue]];
        self.markDesc = dic[@"desc"];
        self.iconUrl = dic[@"icon"];
        self.iconPath = @"";
        self.isIconDownloaded = NO;
        self.lastActiveTime = [NSDate dateWithTimeIntervalSinceNow:0];
        self.lastUpdate = [NSDate dateWithTimeIntervalSinceNow:0];
        self.markName = dic[@"mark_name"];
        self.markNamePinyin = dic[@"mark_name_pinyin"]?dic[@"mark_name"]:@"";
        self.name = dic[@"nick_name"];
        self.namePinyin = dic[@"nick_name_pinyin"];
        self.phone = dic[@"phone"];
        self.uid = dic[@"user_id"];
        self.userType = [dic[@"user_type"] integerValue];
        self.isStar = NO;
        self.configs = dic[@"configs"];
    }
    return self;
}

@end
