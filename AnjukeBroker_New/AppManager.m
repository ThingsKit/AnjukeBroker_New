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

@end
