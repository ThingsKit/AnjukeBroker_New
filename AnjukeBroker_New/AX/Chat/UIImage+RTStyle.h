//
//  UIImage+RTStyle.h
//  RTUIStyle
//
//  Created by liu lh on 13-5-22.
//  Copyright (c) 2013年 liu lh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RTStyle)

- (UIImage *)autoResizableWidthImage;
- (UIImage *)autoResizableHeightImage;
- (UIImage *)autoResizableImage;

+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)resizeImage:(UIImage *)image size:(CGSize)size;
+ (UIImage *)createMaskWithImage:(UIImage *)image outColor:(UIColor *)outColor innerColor:(UIColor *)innerColor;
//+ (UIImage *)getCommonBundleImage:(NSString *)fileName;
+ (UIImage *)getStyleBundleImage:(NSString *)fileName;
+ (UIImage *)autoGetImage:(NSString *)fileName;

+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;

@end
