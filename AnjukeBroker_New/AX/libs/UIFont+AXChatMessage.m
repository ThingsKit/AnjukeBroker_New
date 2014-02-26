//
//  UIFont+AXChatMessage.m
//  Anjuke2
//
//  Created by Gin on 2/24/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import "UIFont+AXChatMessage.h"

@implementation UIFont (AXChatMessage)

+ (UIFont *)axChatTextFont:(BOOL)isBroker
{
    return [UIFont systemFontOfSize:16];
}

+ (UIFont *)axChatSystemFont:(BOOL)isBroker
{
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *)axChatSystemTimeFont:(BOOL)isBroker
{
    return [UIFont systemFontOfSize:12];
}

@end
