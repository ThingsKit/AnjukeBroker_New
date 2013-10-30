//
//  BigImageViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-30.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@protocol BigImageViewBtnClickDelegate <NSObject>

- (void)deletebtnClick;

@end

@interface PropertyBigImageViewController : RTViewController

@property (nonatomic, strong) UIImageView *contentImgView;
@property (nonatomic, assign) id <BigImageViewBtnClickDelegate> btnDelegate;

@end

