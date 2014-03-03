//
//  UIColor+AXChatMessage.h
//  Anjuke2
//
//  Created by Gin on 2/24/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AXChatMessage)

+ (UIColor *)colorWithHex:(uint) hex alpha:(CGFloat)alpha;

+ (UIColor *)axInChatTextColor:(BOOL)isBroker;
+ (UIColor *)axOutChatTextColor:(BOOL)isBroker;

+ (UIColor *)axChatSystemTextColor:(BOOL)isBroker;
+ (UIColor *)axChatSystemLinkColor:(BOOL)isBroker;
+ (UIColor *)axChatSystemLinkHighlightedColor:(BOOL)isBroker;

+ (UIColor *)axInChatTextLinkColor:(BOOL)isBroker;
+ (UIColor *)axOutChatTextLinkColor:(BOOL)isBroker;

+ (UIColor *)axChatPropTagColor:(BOOL)isBroker;
+ (UIColor *)axChatPropDescColor:(BOOL)isBroker;

+ (UIColor *)axChatTimeColor:(BOOL)isBroker;
+ (UIColor *)axChatBGColor:(BOOL)isBroker;
+ (UIColor *)axChatSystemBGColor:(BOOL)isBroker;

+ (UIColor *)axChatInputBGColor:(BOOL)isBroker;
+ (UIColor *)axChatInputBorderColor:(BOOL)isBroker;

+ (UIColor *)axChatSendButtonNColor:(BOOL)isBroker;
+ (UIColor *)axChatSendButtonHColor:(BOOL)isBroker;
+ (UIColor *)axChatSendButtonDColor:(BOOL)isBroker;

@end
