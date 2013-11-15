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
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"token"]) {
        DLog(@"getToken [%@]", [[NSUserDefaults standardUserDefaults] valueForKey:@"token"]);
        return YES;
    }
    
    return NO;
}

+ (void)doLogout {
    //
}

+ (NSString *)getUserName {
    DLog(@"getUserName [%@]", [[NSUserDefaults standardUserDefaults] valueForKey:@"username"]);
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
}

+ (NSString *)getUse_photo_url {
    DLog(@"getUse_photo_url [%@]", [[NSUserDefaults standardUserDefaults] valueForKey:@"userPhoto"]);
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userPhoto"];
}

+ (NSString *)getUserID {
    DLog(@"getUserID [%@]", [[NSUserDefaults standardUserDefaults] valueForKey:@"id"]);
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"id"];
}

+ (NSString *)getCity_id {
    DLog(@"getCity_id [%@]", [[NSUserDefaults standardUserDefaults] valueForKey:@"city_id"]);
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"city_id"];
}

+ (NSString *)getToken {
    DLog(@"getToken [%@]", [[NSUserDefaults standardUserDefaults] valueForKey:@"token"]);
    
//    return [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    return @"14e96260ca470b9afa52a48e3a54fb12";
}


@end
