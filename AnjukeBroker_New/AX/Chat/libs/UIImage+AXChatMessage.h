//
//  UIImage+AXChatMessage.h
//  Anjuke2
//
//  Created by Gin on 2/24/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AXChatMessage)

+ (UIImage *)axChatDefaultAvatar:(BOOL)isBroker;
+ (UIImage *)axChatError:(BOOL)isBroker;
+ (UIImage *)axInChatBubbleBg:(BOOL)isBroker highlighted:(BOOL)highlighted;
+ (UIImage *)axOutChatBubbleBg:(BOOL)isBroker highlighted:(BOOL)highlighted;
+ (UIImage *)axInChatPropBubbleBg:(BOOL)isBroker highlighted:(BOOL)highlighted;
+ (UIImage *)axOutChatPropBubbleBg:(BOOL)isBroker highlighted:(BOOL)highlighted;

@end
