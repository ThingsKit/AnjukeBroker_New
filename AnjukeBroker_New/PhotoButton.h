//
//  PhotoButton.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-24.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoButton : UIButton

@property (nonatomic, strong) UIImageView *photoImg;
@property (nonatomic, strong) UIButton *deletelBtn;

- (void)setPhotoImage:(UIImage *)image;

@end
