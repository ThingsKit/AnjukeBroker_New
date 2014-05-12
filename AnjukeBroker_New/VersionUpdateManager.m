//
//  VersionUpdateManager.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "VersionUpdateManager.h"
#import "RTRequestProxy.h"
#import "AppManager.h"
#import "Reachability.h"

@implementation VersionUpdateManager
- (void)checkVersionForMore:(BOOL)forMore { // 新版本更新检查
    if (![self checkNetwork]) {
        return;
    }
    
//    self.boolNeedAlert = forMore;
    
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
    
    if ([resultFromAPI count] != 0) {
//        self.updateUrl = [NSString stringWithFormat:@"%@",[resultFromAPI objectForKey:@"url"]];
        
        NSString *localVer = [AppManager getBundleVersion];
        
        if ([resultFromAPI objectForKey:@"ver"] != nil && ![[resultFromAPI objectForKey:@"ver"] isEqualToString:@""]) {
            NSString *onlineVer = [resultFromAPI objectForKey:@"ver"];
            
            if ([[resultFromAPI objectForKey:@"is_enforce"] isEqualToString:@"1"]) {
//                self.isEnforceUpdate = YES;
                
//                if ([localVer compare:onlineVer options:NSNumericSearch] == NSOrderedAscending)  {
//                    //强制更新(强制更新且版本号增大)
//                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新%@版本",onlineVer]
//                                                                 message:nil
//                                                                delegate:self
//                                                       cancelButtonTitle:nil
//                                                       otherButtonTitles:@"立即更新", @"退出应用", nil];
//                    av.tag = 101;
//                    [av show];
//                    return;
//                }
            }else{ //非强制更新（非强制更新且版本号增大）
//                self.isEnforceUpdate = NO;
//                
//                if ([localVer compare:onlineVer options:NSNumericSearch] == NSOrderedAscending)  {
//                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新%@版本",onlineVer]
//                                                                 message:nil
//                                                                delegate:self
//                                                       cancelButtonTitle:@"稍后再说"
//                                                       otherButtonTitles:@"立即更新",nil];
//                    av.cancelButtonIndex = 0;
//                    av.tag = 102;
//                    [av show];
//                    
//                    return;
//                }
                
            }
            DLog(@"appVer[%@] checkVer[%@]",localVer, onlineVer);
            
//            if (self.boolNeedAlert) {
//                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"没有发现新版本" delegate:Nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//                [av show];
//                self.boolNeedAlert = NO;
//            }
        }
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
