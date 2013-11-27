//
//  WelcomeScrollview.h
//  AiFang
//
//  Created by Wu sicong on 13-6-26.
//  Copyright (c) 2013年 anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFWelcomeScrollview : UIView <UIScrollViewDelegate>

- (void)setImgArray:(NSArray *)imgArray; //use for show images
- (void)setImageBG:(NSString *)imageName withTitleArray:(NSArray *)titleArray;

@end
