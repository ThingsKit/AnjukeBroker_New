//
//  Util_UI.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-29.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util_UI : NSObject

//动态Lable.text自适应的frame计算
+ (CGSize)sizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(int)fontSize;
+ (CGSize)sizeOfBoldString:(NSString *)string maxWidth:(float)width widthBoldFontSize:(int)fontSize;

// Base Image Fitting
+ (CGSize)fitSize: (CGSize)thisSize inSize: (CGSize) aSize;
+ (CGRect)frameSize: (CGSize)thisSize inSize: (CGSize) aSize;

@end
