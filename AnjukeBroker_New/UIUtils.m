//
//  UIUtils.m
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"

@implementation UIUtils

+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    //两种获取document路径的方式
//    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
    [formatter setDateFormat:formate];
	
    NSString *str = [formatter stringFromDate:date];
    
	return str;
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:formate];
    //ios7以下需要设置Locale,否则string到date的转换为nil
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSDate *date = [formatter dateFromString:datestring];
    
    return date;
}

//源字符串 Thu Jan 02 13:34:50 +0800 2014   -   E M d HH:mm:ss Z yyyy
//目标字符串 01-23 14:52   -  MM-dd HH:mm
//Sat Jan 12 11:50:16 +0800 2013
+ (NSString *)fomateString:(NSString *)datestring {
    NSString *formate = @"E M d HH:mm:ss Z yyyy";
    NSDate *createDate = [UIUtils dateFromFomate:datestring formate:formate];
    NSString *text = [UIUtils stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}

+ (NSString*) replaceWithText:(NSString*) text {

    NSString* regex = @"(@\\w+)|(#\\w+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";
//    NSString* regex = @"(@\\w+)|(#\\w+#)|(http(s)?://[\\w+./]+)";
//    NSString* target = [text stringByReplacingOccurrencesOfRegex:regex withString:@"<a href='$0'>$0</a>"];
    NSArray* matches = [text componentsMatchedByRegex:regex];
    for (NSString* match in matches) {
        NSString* replacement = nil;
        if ([match hasPrefix:@"@"]) {
            replacement = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>", [match URLEncodedString], match];
        }else if([match hasPrefix:@"#"] && [match hasSuffix:@"#"]){
            replacement = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>", [match URLEncodedString], match];
        }else if([match hasPrefix:@"http"]){
            replacement = [NSString stringWithFormat:@"<a href='%@'>%@</a>", match, match];
        }
        
        if (replacement != nil) { //防止报错
            text = [text stringByReplacingOccurrencesOfString:match withString:replacement];
        }
    }
    
    return text;
}

@end
