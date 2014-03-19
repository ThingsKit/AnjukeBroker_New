//
//  WelcomeScrollview.h
//  AiFang
//
//  Created by Wu sicong on 13-6-26.
//  Copyright (c) 2013年 anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFWelcomeScrollViewDelegate <NSObject>

- (void)welcomeViewDidHide;

@end

@interface AFWelcomeScrollview : UIView <UIScrollViewDelegate>

- (void)setImgArray:(NSArray *)imgArray; //use for show images
- (void)setImageBGArr:(NSArray  *)imageBGArr withTitleArray:(NSArray *)titleArray withImgIconArr:(NSArray *)imgIconArr withDetailArr:(NSArray *)detailArr;

@property id <AFWelcomeScrollViewDelegate> delegate;

@end
