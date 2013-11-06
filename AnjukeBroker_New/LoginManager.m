//
//  LoginManager.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-5.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "LoginManager.h"

@implementation LoginManager

+ (BOOL)isLogin {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"]) {
        return YES;
    }
    
    return NO;
}

+ (void)doLogout {
    //
}

+ (NSString *)getUserName {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
}

+ (NSString *)getUse_photo_url {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userPhoto"];
}

+ (NSString *)getUserID {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"id"];
}

+ (NSString *)getCity_id {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"city_id"];
}

+ (NSString *)getToken {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
}


@end
