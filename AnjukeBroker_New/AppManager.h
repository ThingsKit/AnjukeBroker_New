//
//  AppManager.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-14.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject

+ (BOOL)checkPhoneFunction;
+ (BOOL)isFirstLaunch;
+ (NSString *)getBundleVersion;

@end
