//
//  Util_UI.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-29.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "Util_UI.h"

#define DEFAULT_VOID_COLOR [UIColor blackColor]

@implementation Util_UI

// 获取指定最大宽度和字体大小的string的size
+ (CGSize)sizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(int)fontSize {
	UIFont *font = [UIFont systemFontOfSize:fontSize];
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 10000.0f) lineBreakMode:UILineBreakModeWordWrap];
	return size;
}

//获取指定最大宽度和字体大小的string的size（用于粗体字）
+ (CGSize)sizeOfBoldString:(NSString *)string maxWidth:(float)width widthBoldFontSize:(int)fontSize{
    
	UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 10000.0f) lineBreakMode:UILineBreakModeWordWrap];
	return size;
}

+ (CGSize)fitSize: (CGSize)thisSize inSize: (CGSize) aSize
{
	CGFloat scale;
	CGSize newsize = thisSize;
	
	if (newsize.height && (newsize.height > aSize.height))
	{
		scale = aSize.height / newsize.height;
		newsize.width *= scale;
		newsize.height *= scale;
	}
	
	if (newsize.width && (newsize.width >= aSize.width))
	{
		scale = aSize.width / newsize.width;
		newsize.width *= scale;
		newsize.height *= scale;
	}
	
	return newsize;
}

+ (CGRect)frameSize: (CGSize)thisSize inSize: (CGSize) aSize
{
	CGSize size = [self fitSize:thisSize inSize: aSize];
	float dWidth = aSize.width - size.width;
	float dHeight = aSize.height - size.height;
	
	return CGRectMake(dWidth / 2.0f, dHeight / 2.0f, size.width, size.height);
}

+ (UIColor *)colorWithHexString: (NSString *)stringToConvert {
    
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
