//
//  UIColor+RT.h
//  UIComponents
//
//  Created by 丛 贵明 on 12/19/13.
//  Copyright (c) 2013 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RT)

+ (UIColor *)colorWithHex:(uint) hex alpha:(CGFloat)alpha;

//标题大字，正文内容 38,38,38
+ (UIColor *)ajkBlackColor;

//小标题，附属说明文字 141,140,146
+ (UIColor *)ajkMiddleGrayColor;

//输入框内的提示文字 204,204,206
+ (UIColor *)ajkLightGrayColor;

//255,255,255
+ (UIColor *)ajkWhiteColor;

//按钮文字，链接文字 100,169,0
+ (UIColor *)ajkGreenColor;

//房价，套数 229,75,0
+ (UIColor *)ajkOrangeColor;

//各页面背景 244,244,245
+ (UIColor *)ajkBackgroundPageColor;

//部分栏的背景色 248,248,249
+ (UIColor *)ajkBackgroundBarColor;

//内容区的背景色 255,255,255
+ (UIColor *)ajkBackgroundContentColor;

//页面和列表的分割线 200,199,204
+ (UIColor *)ajkLineColor;

//选中背景色 234,234,234
+ (UIColor *)ajkBgSelectColor;

//深绿 35,140,0
+ (UIColor *)ajkDarkGreenColor;

//文字按钮色 60,60,61
+ (UIColor *)ajkBtnText;

@end
