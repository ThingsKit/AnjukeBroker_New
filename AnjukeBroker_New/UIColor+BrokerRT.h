
//
//  UIColor+BrokerRT.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-19.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BrokerRT)

+ (UIColor *)colorWithHex:(uint) hex alpha:(CGFloat)alpha;

//标题大字，正文内容
+ (UIColor *)brokerBlackColor;
//小标题，附属说明文字
+ (UIColor *)brokerMiddleGrayColor;
//辅助提示文字
+ (UIColor *)brokerLightGrayColor;
// 深色背景上文字
+ (UIColor *)brokerWhiteColor;
//底Tab选中色
+ (UIColor *)brokerBlueColor;
//按钮色
+ (UIColor *)brokerBabyBlueColor;
//气泡
+ (UIColor *)brokerRedColor;
//蓝灰色
+ (UIColor *)brokerBlueGrayColor;
//蓝黑色_i,顶部与底部_ios
+ (UIColor *)brokerBlueBlackColor_i;
//绿色
+ (UIColor *)brokerGreenColor;
//各页面背景
+ (UIColor *)brokerBgPageColor;
//选中背景色
+ (UIColor *)brokerBgSelectColor;
//分割线
+ (UIColor *)brokerLineColor;

@end
