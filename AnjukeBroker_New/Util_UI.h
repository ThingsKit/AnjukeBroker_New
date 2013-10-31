//
//  Util_UI.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-29.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYSTEM_BLUE [Util_UI colorWithHexString:@"2087fc"]
#define SYSTEM_BLACK [Util_UI colorWithHexString:@"333333"]
#define SYSTEM_LIGHT_GRAY [Util_UI colorWithHexString:@"999999"]
#define SYSTEM_LIGHT_GRAY_BG [Util_UI colorWithHexString:@"EFEFF4"]

@interface Util_UI : NSObject

//动态Lable.text自适应的frame计算
+ (CGSize)sizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(int)fontSize;
+ (CGSize)sizeOfBoldString:(NSString *)string maxWidth:(float)width widthBoldFontSize:(int)fontSize;

// Base Image Fitting
+ (CGSize)fitSize: (CGSize)thisSize inSize: (CGSize) aSize;
+ (CGRect)frameSize: (CGSize)thisSize inSize: (CGSize) aSize;

+ (UIColor *)colorWithHexString: (NSString *)stringToConvert;

@end
