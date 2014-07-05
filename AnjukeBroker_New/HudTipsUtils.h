//
//  HudTipsUtils.h
//  AnjukeBroker_New
//
//  Created by jason on 7/5/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HudTipsUtils : UIView

+ (id)sharedInstance;

- (void)displayHUDWithStatus:(NSString *)status Message:(NSString*)message ErrCode:(NSString*)errCode toView:(UIView *)view;

@end
