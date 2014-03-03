//
//  UIColor+RT.m
//  UIComponents
//
//  Created by 丛 贵明 on 12/19/13.
//  Copyright (c) 2013 anjuke inc. All rights reserved.
//

#import "UIColor+RT.h"

@implementation UIColor (RT)

+ (UIColor *) colorWithHex:(uint) hex alpha:(CGFloat)alpha
{
	int red, green, blue;
	
	blue = hex & 0x0000FF;
	green = ((hex & 0x00FF00) >> 8);
	red = ((hex & 0xFF0000) >> 16);
	
	return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (UIColor *)ajkBlackColor {
    return [UIColor colorWithHex:0x262626 alpha:1];
}

+ (UIColor *)ajkMiddleGrayColor {
    return [UIColor colorWithHex:0x8d8c92 alpha:1];
}

+ (UIColor *)ajkLightGrayColor {
    return [UIColor colorWithHex:0xccccce alpha:1];
}

+ (UIColor *)ajkWhiteColor {
    return [UIColor colorWithHex:0xffffff alpha:1];
}

+ (UIColor *)ajkOrangeColor {
    return [UIColor colorWithHex:0xe54b00 alpha:1];
}

+ (UIColor *)ajkBackgroundPageColor {
    return [UIColor colorWithHex:0xf4f4f5 alpha:1];
}

+ (UIColor *)ajkBackgroundBarColor {
    return [UIColor colorWithHex:0xf8f8f9 alpha:1];
}

+ (UIColor *)ajkBackgroundContentColor {
    return [UIColor colorWithHex:0xffffff alpha:1];
}

+ (UIColor *)ajkLineColor {
    return [UIColor colorWithHex:0xc8c7cc alpha:1];
}

+ (UIColor *)ajkBgSelectColor {
    return [UIColor colorWithHex:0xEAEAEA alpha:1];
}

+ (UIColor *)ajkGreenColor {
    return [UIColor colorWithHex:0x69Af00 alpha:1];
}

+ (UIColor *)ajkDarkGreenColor {
    return [UIColor colorWithHex:0x238C00 alpha:1];
}

@end
