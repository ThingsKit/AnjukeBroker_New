//
//  VersionUpdateManager.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTRequestProxy.h"
#import "AppManager.h"
#import "Reachability.h"

@protocol updateVersionDelegate <NSObject>
- (void)updateVersionInfo:(NSDictionary *)dic;
@end

@interface VersionUpdateManager : NSObject
@property(nonatomic, assign) BOOL isDefaultLoad;
@property(nonatomic, assign) BOOL isNeedAlert;
@property(nonatomic, assign) BOOL isEnforceUpdate;
@property(nonatomic, strong) NSString *updateUrl;
@property(nonatomic, assign) id<updateVersionDelegate> versionDelegate;

- (void)checkVersion:(BOOL)isForDefaultLoad;
@end
