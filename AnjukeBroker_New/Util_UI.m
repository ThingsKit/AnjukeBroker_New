//
//  Util_UI.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-29.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "Util_UI.h"

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

#pragma mark - UIImageFitSize
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

@end
