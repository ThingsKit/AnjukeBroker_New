//
//  LoginManager.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-5.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

+ (BOOL)isLogin; //登录状态判断
+ (void)doLogout;
+ (NSString *)getUserName;
+ (NSString *)getUse_photo_url;
+ (NSString *)getUserID;
+ (NSString *)getCity_id;
+ (NSString *)getToken;

@end
