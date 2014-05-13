//
//  UIUtils.h
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CONSTS.h"

@interface UIUtils : NSObject

//获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName;
// date 格式化为 string
+ (NSString*)stringFromFomate:(NSDate*)date formate:(NSString*)formate;
// string 格式化为 date
+ (NSDate *)dateFromFomate:(NSString *)datestring formate:(NSString*)formate;

//新浪微博日期格式化
//源字符串 Thu Jan 02 13:34:50 +0800 2014   -   E M d HH:mm:ss Z yyyy
//目标字符串 01-23 14:52   -  MM-dd HH:mm
+ (NSString *)fomateString:(NSString *)datestring;

//替换文件为超链接文本
+ (NSString*) replaceWithText:(NSString*) sourceText;

@end
