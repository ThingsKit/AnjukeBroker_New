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
#define SYSTEM_LIGHT_GRAY_BG2 [Util_UI colorWithHexString:@"eeeeee"]

#define SYSTEM_DARK_GRAY [Util_UI colorWithHexString:@"666666"]
#define SYSTEM_GREEN [Util_UI colorWithHexString:@"66cc00"]
#define SYSTEM_ORANGE [Util_UI colorWithHexString:@"FF6600"]
#define SYSTEM_RED [UIColor colorWithRed:0.99 green:0.24 blue:0.22 alpha:1]

#define SYSTEM_ZZ_RED [UIColor colorWithRed:0.93 green:0.24 blue:0.25 alpha:1]
#define SYSTEM_NAVBAR_DARK_BG [Util_UI colorWithHexString:@"252D3B"]
#define SYSTEM_NAVIBAR_COLOR [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define SYSTEM_TABBAR_SELECTCOLOR_DARK [Util_UI colorWithHexString:@"0079FF"]

@interface Util_UI : NSObject

//动态Lable.text自适应的frame计算
+ (CGSize)sizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(int)fontSize;
+ (CGSize)sizeOfBoldString:(NSString *)string maxWidth:(float)width widthBoldFontSize:(int)fontSize;

// Base Image Fitting
+ (CGSize)fitSize: (CGSize)thisSize inSize: (CGSize) aSize;
+ (CGRect)frameSize: (CGSize)thisSize inSize: (CGSize) aSize;

+ (UIColor *)colorWithHexString: (NSString *)stringToConvert;

@end
