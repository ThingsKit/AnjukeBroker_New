//
//  CallAlert.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BrokerCallAlert.h"
#import "AppManager.h"
#import "BrokerLogger.h"

@interface BrokerCallAlert ()
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *logKey;
@end

@implementation BrokerCallAlert
static BrokerCallAlert* defaultCallAlert;

+ (BrokerCallAlert *) sharedCallAlert{
    @synchronized(self){
        if (defaultCallAlert == nil) {
            defaultCallAlert = [[BrokerCallAlert alloc] init];
        }
        return defaultCallAlert;
    }
}
- (void)callAlert:(NSString *)alertStr callPhone:(NSString *)callPhone appLogKey:(NSString *)appLogKey{
    self.phoneNum = [NSString stringWithFormat:@"%@",callPhone];
    self.logKey = [NSString stringWithFormat:@"%@",appLogKey];
    if (!self.phoneNum || [self.phoneNum isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"暂无号码，无法拨打" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
        return;
    }
    if (![AppManager checkPhoneFunction]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请检测是否支持电话功能" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
        return;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@%@",alertStr,self.phoneNum] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        alert.tag = 10;
        [alert show];
    }
}


#pragma -mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10 && buttonIndex == 1) {
        if (self.logKey && ![self.logKey isEqualToString:@""]) {
            [[BrokerLogger sharedInstance] logWithActionCode:self.logKey note:nil];
        }
        NSString *call_url = [[NSString alloc] initWithFormat:@"tel://%@", self.phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:call_url]];
    }
}
@end
