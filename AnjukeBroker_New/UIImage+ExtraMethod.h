//
//  UIImage+ExtraMethod.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-23.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ExtraMethod)
/*
 * 按照Rect截取Image里一块生成新的image
 */
- (UIImage *)getSubImage:(CGRect)rect;

/*
 * 按照size缩小
 */
- (UIImage *)scaleToSize:(CGSize)size;

/**
 * 调整图片大小至适合屏幕
 */
- (UIImage *)imageWithAspectFillStyle;

/*
 * 按照VGA缩小
 */
- (UIImage *)scaleToVGA;

/*
 * 获取图片内存大小
 */
- (size_t)imageBytesSize;

/*
 * 反转成向上方向
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

/*
 * 获取bundle中的图片
 */
+ (UIImage *)imageNamedForBundle:(NSString *)name;

/*
 * 图片模糊处理
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

/*
 *iphone5图片处理
 */
+ (UIImage*)imageNamedForDevice:(NSString*)name;

@end
