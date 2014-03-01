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
    [self cleanToken];
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
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
//    return @"14e96260ca470b9afa52a48e3a54fb12";
}

+ (void)cleanToken {
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"token"];
    DLog(@"clean Token [%@]", [[NSUserDefaults standardUserDefaults] valueForKey:@"token"]);
}

+ (NSString *)getName {
    DLog(@"getName [%@]", [[NSUserDefaults standardUserDefaults] valueForKey:@"name"]);
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"name"];
}

+ (NSString *)getPhone {
    DLog(@"getPhone [%@]", [[NSUserDefaults standardUserDefaults] valueForKey:@"phone"]);
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"phone"];
}

+ (NSString *)getChatID {
    DLog(@"chatID [%@]", [[NSUserDefaults standardUserDefaults] valueForKey:@"chatID"]);
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"chatID"];
}

+ (NSString *)getChatToken {
    DLog(@"tokenChat [%@]", [[NSUserDefaults standardUserDefaults] valueForKey:@"tokenChat"]);
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"tokenChat"];
}

//得到二维码
+ (NSString *)getTwoCodeIcon {
    DLog(@"twoCodeIcon [%@]", [[NSUserDefaults standardUserDefaults] valueForKey:@"twoCodeIcon"]);
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"twoCodeIcon"];
}

+ (BOOL)isSeedForAJK:(BOOL)isAJK {
    NSString *isSeedStr = [NSString string];
    
    if (isAJK) {
        isSeedStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"isSeed_AJK"];
    }
    else
        isSeedStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"isSeed_HZ"];
    
    if ([isSeedStr isEqualToString:@"1"]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)needFileNOWithCityID:(NSString *)cityID {
    //test
    if ([cityID intValue] == 14) { //默认北京需要备案号
        return YES;
    }
    
    return NO;
}

+ (NSDictionary *)getFuckingChatUserDicJustForAnjukeTeam {
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    [userDic setObject:[self getPhone] forKey:@"phone"];
    [userDic setObject:[self getChatID] forKey:@"user_id"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:userDic forKey:@"user_info"];
    
    return dic;
}

+ (NSDictionary *)getFuckingChatUserDicJustForAnjukeTeamWithPhone:(NSString *)phone uid:(NSString *)uid {
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    if (phone) {
        [userDic setObject:phone forKey:@"phone"];
    }
    if (uid) {
        [userDic setObject:uid forKey:@"user_id"];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:userDic forKey:@"user_info"];
    
    return dic;
}


@end
