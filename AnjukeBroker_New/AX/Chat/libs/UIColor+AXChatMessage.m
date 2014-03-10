//
//  UIColor+AXChatMessage.m
//  Anjuke2
//
//  Created by Gin on 2/24/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import "UIColor+AXChatMessage.h"

@implementation UIColor (AXChatMessage)

+ (UIColor *)colorWithHex:(uint) hex alpha:(CGFloat)alpha
{
    int red, green, blue;
	
	blue = hex & 0x0000FF;
	green = ((hex & 0x00FF00) >> 8);
	red = ((hex & 0xFF0000) >> 16);
	
	return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (UIColor *)axInChatTextColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0x000000 alpha:1];
    } else {
        return [UIColor colorWithHex:0x343434 alpha:1];
    }
}

+ (UIColor *)axOutChatTextColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0xffffff alpha:1];
    } else {
        return [UIColor colorWithHex:0x343434 alpha:1];
    }
}

+ (UIColor *)axChatSystemTextColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0x666666 alpha:1];
    } else {
        return [UIColor colorWithHex:0x919191 alpha:1];
    }
}

+ (UIColor *)axChatSystemLinkColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0x3E93D9 alpha:1];
    } else {
        return [UIColor colorWithHex:0x5882af alpha:1];
    }
}

+ (UIColor *)axChatSystemLinkHighlightedColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0x3E93D9 alpha:1];
    } else {
        return [UIColor colorWithHex:0x144b7e alpha:1];
    }
}

+ (UIColor *)axInChatTextLinkColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0x3E94DA alpha:1];
    } else {
        return [UIColor colorWithHex:0x3A7EC0 alpha:1];
    }
}

+ (UIColor *)axOutChatTextLinkColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0x92FFFF alpha:1];
    } else {
        return [UIColor colorWithHex:0x3A7EC0 alpha:1];
    }
}

+ (UIColor *)axChatPropTagColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0x999999 alpha:1];
    } else {
        return [UIColor colorWithHex:0x919191 alpha:1];
    }
}

+ (UIColor *)axChatPropDescColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0x000000 alpha:1];
    } else {
        return [UIColor colorWithHex:0x999999 alpha:1];
    }
}

+ (UIColor *)axChatTimeColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0x666666 alpha:1];
    } else {
        return [UIColor colorWithHex:0x919191 alpha:1];
    }
}

+ (UIColor *)axChatBGColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0xe6e5e6 alpha:1];
    } else {
        return [UIColor colorWithHex:0xf8f8f8 alpha:1];
    }
}

+ (UIColor *)axChatSystemBGColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0x000000 alpha:0.1];
    } else {
        return [UIColor colorWithHex:0xe6e6e6 alpha:1];
    }
}

+ (UIColor *)axChatInputBGColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0xe6e6e6 alpha:1];
    } else {
        return [UIColor colorWithHex:0xe6e6e6 alpha:1];
    }
}

+ (UIColor *)axChatInputBorderColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0xcccccc alpha:1];
    } else {
        return [UIColor colorWithHex:0xcccccc alpha:1];
    }
}

+ (UIColor *)axChatSendButtonNColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0x60a410 alpha:1];
    } else {
        return [UIColor colorWithHex:0x60a410 alpha:1];
    }
}

+ (UIColor *)axChatSendButtonHColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0x60a410 alpha:1];
    } else {
        return [UIColor colorWithHex:0x60a410 alpha:1];
    }
}

+ (UIColor *)axChatSendButtonDColor:(BOOL)isBroker
{
    if (isBroker) {
        return [UIColor colorWithHex:0xa7a7a7 alpha:1];
    } else {
        return [UIColor colorWithHex:0xa7a7a7 alpha:1];
    }
}



@end
