//
//  VersionUpdateManager.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "VersionUpdateManager.h"


@implementation VersionUpdateManager
@synthesize versionDelegate,isDefaultLoad,isNeedAlert,isEnforceUpdate;

- (void)checkVersion:(BOOL)isForDefaultLoad{ // 新版本更新检查
    if (![self checkNetwork]) {
        [versionDelegate updateVersionInfo:nil];
        return;
    }
    self.isDefaultLoad = isForDefaultLoad;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"i" ,@"o" , nil];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"checkversion/" params:params target:self action:@selector(onGetVersion:)];
}

- (void)onGetVersion:(RTNetworkResponse *) response {
    //check network and response
    if (![self checkNetwork])
        return;
    
    if ([response status] == RTNetworkResponseStatusFailed || ([[[response content] objectForKey:@"status"] isEqualToString:@"error"]))
        return;
    
    NSDictionary *resultFromAPI = [[response content] objectForKey:@"data"];
    DLog(@"%@", resultFromAPI);

    if (!self.isDefaultLoad) {
        [versionDelegate updateVersionInfo:resultFromAPI];
        return;
    }
    
    if ([resultFromAPI count] != 0) {
        self.updateUrl = [NSString stringWithFormat:@"%@",[resultFromAPI objectForKey:@"url"]];
        
        NSString *localVer = [AppManager getBundleVersion];
        
        if ([resultFromAPI objectForKey:@"ver"] != nil && ![[resultFromAPI objectForKey:@"ver"] isEqualToString:@""]) {
            NSString *onlineVer = [resultFromAPI objectForKey:@"ver"];
            
            if ([[resultFromAPI objectForKey:@"is_enforce"] isEqualToString:@"1"]) {
                self.isEnforceUpdate = YES;
                
                if ([localVer compare:onlineVer options:NSNumericSearch] == NSOrderedAscending)  {
                    //强制更新(强制更新且版本号增大)
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新%@版本",onlineVer]
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"立即更新", @"退出应用", nil];
                    av.tag = 101;
                    [av show];
                    return;
                }
            }else{ //非强制更新（非强制更新且版本号增大）
                if ([localVer compare:onlineVer options:NSNumericSearch] == NSOrderedAscending)  {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新%@版本",onlineVer]
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"稍后再说"
                                                       otherButtonTitles:@"立即更新",nil];
                    av.cancelButtonIndex = 0;
                    av.tag = 102;
                    [av show];
                    
                    return;
                }
                
            }
            DLog(@"appVer[%@] checkVer[%@]",localVer, onlineVer);
        }
    }
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 101){
        if (buttonIndex == 0) {
            if (self.isEnforceUpdate) { //更新
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
                
                exit(0); //强制更新后跳转且退出应用
            }
        }
        if (buttonIndex == 1) {
            if (self.isEnforceUpdate) { //退出应用
                exit(0);
            }
            else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
            }
        }
    }else if (alertView.tag == 102){
        if (buttonIndex == 0) {
        }
        if (buttonIndex == 1) {
            //更新
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
            exit(0); //强制更新后跳转且退出应用
        }
    }else{
    }
}

- (BOOL)checkNetwork {
    // check if network is available
    if (![[RTRequestProxy sharedInstance] isInternetAvailiable]) {
        return NO;
    }
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    if ([r currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    
    return YES;
}
@end
