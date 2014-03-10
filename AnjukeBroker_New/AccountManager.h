//
//  AccountManager.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-25.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginManager.h"

@interface AccountManager : NSObject
@property (nonatomic, copy) NSString *NotificationDeviceToken;

+ (id)sharedInstance;
- (id)init;

- (void)registerNotification;
- (void)cleanNotificationForLoginOut;
- (BOOL)didMaxClientAlertWithCount:(int)count;

@end
