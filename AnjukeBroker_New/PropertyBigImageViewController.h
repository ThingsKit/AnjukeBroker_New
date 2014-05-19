//
//  BigImageViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-30.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "BK_WebImageView.h"

@protocol BigImageViewBtnClickDelegate <NSObject>

- (void)deletebtnClickForOnlineImg:(BOOL)isOnlineImg;

@end

@interface PropertyBigImageViewController : RTViewController

@property (nonatomic, strong) BK_WebImageView *contentImgView;
@property (nonatomic, assign) id <BigImageViewBtnClickDelegate> btnDelegate;
@property BOOL isOnlineImg;

@end

