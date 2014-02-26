//
//  UIFont+AXChatMessage.h
//  Anjuke2
//
//  Created by Gin on 2/24/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (AXChatMessage)

+ (UIFont *)axChatTextFont:(BOOL)isBroker;
+ (UIFont *)axChatSystemFont:(BOOL)isBroker;
+ (UIFont *)axChatSystemTimeFont:(BOOL)isBroker;

@end
