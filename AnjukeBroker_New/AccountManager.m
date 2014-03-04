//
//  AccountManager.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-25.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AccountManager.h"

@implementation AccountManager
@synthesize NotificationDeviceToken;


+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static AccountManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[AccountManager alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)registerNotification{
    return;
    
    if ([LoginManager isLogin] && self.NotificationDeviceToken.length>20 && [[LoginManager getChatID] length] > 0) {
        NSMutableDictionary *bodys = [NSMutableDictionary dictionary];
        [bodys setValue:@"i-broker2" forKey:@"appName"];
        [bodys setValue:[LoginManager getCity_id] forKey:@"cityId"];
//        [bodys setValue:[LoginManager getUserID] forKey:@"userId"];
        [bodys setValue:[LoginManager getChatID] forKey:@"userId"];
        [bodys setValue:[[UIDevice currentDevice] uuid] forKey:@"uuid"];
        [bodys setValue:[[UIDevice currentDevice] macaddress] forKey:@"macAddress"];
#ifdef JAILBREAK
        [bodys setValue:@"1" forKey:@"breakout"];
#else
        [bodys setValue:@"0" forKey:@"breakout"];
#endif
        DLog(@"bodys %@", bodys);
        [[RTRequestProxy sharedInstance] asyncRESTNotificationWithBodys:bodys token:self.NotificationDeviceToken target:self action:@selector(registerNotificationFinish:)];
    }
}

- (void)cleanNotificationForLoginOut{
    if ([LoginManager isLogin] && self.NotificationDeviceToken.length>20) {
        NSMutableDictionary *bodys = [NSMutableDictionary dictionary];
        [bodys setValue:@"i-broker2" forKey:@"appName"];
        [bodys setValue:[LoginManager getCity_id] forKey:@"cityId"];
        [bodys setValue:@"0"forKey:@"userId"]; //重置userID为0，退出登录时使用
        [bodys setValue:[[UIDevice currentDevice] uuid] forKey:@"uuid"];
        [bodys setValue:[[UIDevice currentDevice] macaddress] forKey:@"macAddress"];
#ifdef JAILBREAK
        [bodys setValue:@"1" forKey:@"breakout"];
#else
        [bodys setValue:@"0" forKey:@"breakout"];
#endif
        DLog(@"bodys %@", bodys);
        [[RTRequestProxy sharedInstance] asyncRESTNotificationWithBodys:bodys token:self.NotificationDeviceToken target:self action:@selector(registerNotificationFinish:)];
    }
}

- (void)registerNotificationFinish:(RTNetworkResponse *)response{
    DLog(@"registerNotificationFinish %@", response.content);
}

@end
