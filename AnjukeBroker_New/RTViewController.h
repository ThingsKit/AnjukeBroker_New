//
//  AJK_RTViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-16.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OriginH_WithNav 20+44
#define OriginH_WithoutNav 20

#define FRAME_BETWEEN_NAV_TAB CGRectMake(0, 0, [self windowWidth], [self windowHeight]-44)
#define FRAME_WITH_NAV CGRectMake(0, 0, [self windowWidth], [self windowHeight] -44)

#define ITEM_BTN_FRAME CGRectMake(0, 0, 55, 31)

@interface RTViewController : UIViewController

- (void)setTitleViewWithString:(NSString *)titleStr;
- (void)initModel;
- (void)initDisplay;
- (NSInteger)windowHeight;
- (NSInteger)windowWidth;

@end
