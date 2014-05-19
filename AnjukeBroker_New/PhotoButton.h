//
//  PhotoButton.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-24.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BK_WebImageView.h"

@interface PhotoButton : UIButton

@property (nonatomic, strong) BK_WebImageView *photoImg;
@property (nonatomic, strong) UIButton *deletelBtn;

- (void)setPhotoImage:(UIImage *)image;
- (void)showDeleteBtn;

@end
