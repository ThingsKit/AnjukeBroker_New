//
//  AppManager.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-14.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

+ (BOOL)checkPhoneFunction {
    UIDevice *device = [UIDevice currentDevice];
    if ([@"iPhone" isEqualToString:device.model])
        return YES;
    else
        return NO;
}

+ (NSString *)getBundleVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (BOOL)isFirstLaunch {
    NSString *key = [NSString stringWithFormat:@"1stLaunch_%@", [self getBundleVersion]];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:key] isEqualToString:@"1"]) {
        return NO; //非首次登录
    }
    [self setLaunchingFlag]; //首次登录，展示引导页
    return YES;
}

+ (void)setLaunchingFlag { //将当前版本第一次开机falg固化
    NSString *key = [NSString stringWithFormat:@"1stLaunch_%@", [self getBundleVersion]];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:key];
    
    DLog(@"BundleVersion %@", [[NSUserDefaults standardUserDefaults] valueForKey:key]);
}

@end
