//
//  UIComponents.h
//  UIComponents
//
//  Created by zheng yan on 12-6-25.
//  Copyright (c) 2012年 anjuke. All rights reserved.
//

#import "UIColor+RT.h"
#import "UIViewController+Loading.h"
#import "UIImage+RTStyle.h"
#import "UIBarButtonItem+NavItem.h"
#import "UILabel+TitleView.h"
#import "UIImage+ExtraMethod.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_6_0
#define NSLineBreakMode                 UILineBreakMode
#define NSLineBreakByWordWrapping       UILineBreakModeWordWrap
#define NSLineBreakByCharWrapping       UILineBreakModeCharacterWrap
#define NSLineBreakByClipping       UILineBreakModeClip
#define NSLineBreakByTruncatingHead     UILineBreakModeHeadTruncation
#define NSLineBreakByTruncatingTail     UILineBreakByTruncatingTail
#define NSLineBreakByTruncatingMiddle   UILineBreakModeMiddleTruncation

#define NSTextAlignment                 UITextAlignment
#define NSTextAlignmentLeft                UITextAlignmentLeft
#define NSTextAlignmentCenter            UITextAlignmentCenter
#define NSTextAlignmentRight            UITextAlignmentRight
#endif

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define is4Inch  ([[UIScreen mainScreen] bounds].size.height == 568) ? TRUE : FALSE

