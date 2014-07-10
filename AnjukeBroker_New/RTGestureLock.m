//
//  RTGestureLock.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-16.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTGestureLock.h"
#import "RTGestureBackNavigationController.h"

@implementation RTGestureLock

+ (void)setDisableGestureForBack:(BK_RTNavigationController *)nav disableGestureback:(BOOL)disableGestureback{
    RTGestureBackNavigationController *passNav = (RTGestureBackNavigationController*)nav;
    if ([passNav isKindOfClass:[RTGestureBackNavigationController class]])
    {
        passNav.disableGestureForBack = disableGestureback;
    }
    
}
@end
