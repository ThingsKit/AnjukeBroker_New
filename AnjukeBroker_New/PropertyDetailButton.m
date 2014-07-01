//
//  PropertyDetailButton.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PropertyDetailButton.h"

@implementation PropertyDetailButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor brokerWhiteColor] forState:UIControlStateNormal];
        // 设置按钮文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 让图片按照原来的宽高比显示出来
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        // 设置按钮文字的字体
        self.titleLabel.font = [UIFont ajkH2Font];
        // 设置按钮里面的内容（UILabel、UIImageView）居中
        // btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return self;
}

#pragma mark - 重写了UIButton的方法
#pragma mark 控制UILabel的位置和尺寸
// contentRect其实就是按钮的位置和尺寸
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height * 100;
    CGFloat titleWidth = contentRect.size.width;
    CGFloat titleHeight = contentRect.size.height - titleY;
    
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

#pragma mark 控制UIImageView的位置和尺寸
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = contentRect.size.height * 100;
    
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

@end
