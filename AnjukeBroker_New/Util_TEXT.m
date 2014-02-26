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
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *postComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:postDate];
    if (nowComponents.year == postComponents.year )
        [dateFormatter setDateFormat:@"MM-dd"];
    else
        [dateFormatter setDateFormat:@"yyyy-MM"];
    
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

@end
