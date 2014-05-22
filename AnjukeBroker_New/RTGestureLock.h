//
//  RTGestureLock.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-16.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BK_RTNavigationController.h"

@interface RTGestureLock : NSObject

+ (void)setDisableGestureForBack:(BK_RTNavigationController *)nav disableGestureback:(BOOL)disableGestureback;
@end
