//
//  RTTabBarItem.h
//  RTUIStyle
//
//  Created by liu lh on 13-5-22.
//  Copyright (c) 2013年 liu lh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BK_RTTabBarItem : UITabBarItem

@property (nonatomic, retain) UIImage *rtSelectedImage;
@property (nonatomic, retain) UIImage *rtUnSelecteddImage;

- (void)setIconWithImage:(UIImage *)image selectionIndicatorImage:(UIImage *)indicatorImage selectionIndicatorColor:(UIColor *)indicatorColor;

@end
