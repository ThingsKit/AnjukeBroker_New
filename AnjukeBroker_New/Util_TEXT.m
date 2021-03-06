//
//  Util_TEXT.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-31.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "Util_TEXT.h"

@implementation Util_TEXT

+ (NSString *)getDateStrWithDate:(NSDate *)applyDate {
    NSString *str = [NSString string];
    
    NSDate *postDate = applyDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *postComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:postDate];
    if (nowComponents.year == postComponents.year ) {
        NSDateComponents *nowComponentsMonth = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:[NSDate date]];
        NSDateComponents *postComponentsMonth = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:postDate];
        NSDateComponents *nowComponentsDay = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:[NSDate date]];
        NSDateComponents *postComponentsDay = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:postDate];
        if (nowComponentsDay.day == postComponentsDay.day && nowComponentsMonth.month == postComponentsMonth.month) { //月、日比较
            [dateFormatter setDateFormat:@"HH:mm"]; //今日
        }
        else
            [dateFormatter setDateFormat:@"MM月dd日"]; //今年
    }
    else
        [dateFormatter setDateFormat:@"MM月dd日"];
    
    str = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:postDate]];
    
    return str;
}

+ (NSString *)logTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd HH:mm:ss.SSS", nil)];
    NSString *now = [formatter stringFromDate:[NSDate date]];
    return now;
}

//去掉string内的' '
+ (NSString *)rmBlankFromString:(NSString *)oldStr {
    if (oldStr == nil || [oldStr isEqualToString:@""] || [oldStr isEqualToString:@" "]) {
		return @"";
	}else {
		NSString *newStr = [[NSString alloc] initWithString:[oldStr stringByReplacingOccurrencesOfString:@" " withString:@""]];
		return newStr;
	}
    
    return oldStr;
}

//将用户电话转化为特定显示
+ (NSString *)getChatNameWithPhoneFormat:(NSString *)phoneStr {
    if (phoneStr.length <= 0 || phoneStr == nil) {
        return @"";
    }
    
    NSMutableString *str = [NSMutableString stringWithString:phoneStr];
    NSString *strName = [str substringToIndex:4];
    
    return [NSString stringWithFormat:@"找房用户 %@*******", strName];
}

//字符串是否为纯数字
+ (BOOL)isNumber:(NSString *)input {
    char *word = (char *)[input UTF8String];
    int len = strlen(word);
    for (int j = 0; j < len; j++) {
        if (word[j] < 48 || word[j] > 57) {
            return NO;
        }
    }
    return YES;
}

@end
