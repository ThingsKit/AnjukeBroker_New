//
//  RTTabBarItem.m
//  RTUIStyle
//
//  Created by liu lh on 13-5-22.
//  Copyright (c) 2013年 liu lh. All rights reserved.
//

#import "BK_RTTabBarItem.h"
#import "UIImage+RTStyle.h"

@implementation BK_RTTabBarItem

@synthesize rtSelectedImage = _rtSelectedImage;
@synthesize rtUnSelecteddImage = _rtUnSelecteddImage;

- (UIImage *)selectedImage {
    if (self.rtSelectedImage == nil) {
        return self.image;
    }
    return self.rtSelectedImage;
}

- (UIImage *)unselectedImage {
    if (self.rtUnSelecteddImage == nil) {
        return self.image;
    }
    return self.rtUnSelecteddImage;
}

- (void)setIconWithImage:(UIImage *)image selectionIndicatorImage:(UIImage *)indicatorImage selectionIndicatorColor:(UIColor *)indicatorColor{
    UIImage *icon = image;
    if (indicatorImage != nil) {
        UIImage* backgroundImage = [UIImage resizeImage:indicatorImage size:image.size];
        
        UIImage* bwImage = [UIImage createMaskWithImage:icon outColor:[UIColor whiteColor] innerColor:[UIColor blackColor]];
        CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(bwImage.CGImage),
                                                 CGImageGetHeight(bwImage.CGImage),
                                                 CGImageGetBitsPerComponent(bwImage.CGImage),
                                                 CGImageGetBitsPerPixel(bwImage.CGImage),
                                                 CGImageGetBytesPerRow(bwImage.CGImage),
                                                 CGImageGetDataProvider(bwImage.CGImage), NULL, YES);
        
        CGImageRef tabBarImageRef = CGImageCreateWithMask(backgroundImage.CGImage, imageMask);
        
        icon = [UIImage imageWithCGImage:tabBarImageRef scale:icon.scale orientation:icon.imageOrientation];
        
        CGImageRelease(imageMask);
        CGImageRelease(tabBarImageRef);
        
    }else if (indicatorColor != nil) {
        icon = [UIImage createMaskWithImage:icon outColor:[UIColor clearColor] innerColor:indicatorColor];
    }
    self.rtSelectedImage = icon;
}

@end
