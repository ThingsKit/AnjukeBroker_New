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
#import "RTViewController.h"

@interface BrokerCallAlert ()
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *logKey;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) void (^completion)(CFAbsoluteTime time);
@end

@implementation BrokerCallAlert
static BrokerCallAlert* defaultCallAlert;

- (id)init
{
    self = [super init];
    if (self) {
        if (!self.webView) {
            self.webView = [[UIWebView alloc] init];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        }
    }
    return self;
}

+ (BrokerCallAlert *) sharedCallAlert{
    @synchronized(self){
        if (defaultCallAlert == nil) {
            defaultCallAlert = [[BrokerCallAlert alloc] init];
        }
        return defaultCallAlert;
    }
}
- (void)willEnterForeground:(NSNotification *)notification{
    self.completion(CFAbsoluteTimeGetCurrent());
    if (self.logKey && ![self.logKey isEqualToString:@""]) {
        [[BrokerLogger sharedInstance] logWithActionCode:self.logKey page:self.page note:nil];
    }
}
- (void)callAlert:(NSString *)alertStr callPhone:(NSString *)callPhone appLogKey:(NSString *)appLogKey page:(NSString *)page completion:(void (^)(CFAbsoluteTime))completion{

    self.completion = completion;
    self.phoneNum = [NSString stringWithFormat:@"%@",callPhone];
    self.logKey = [NSString stringWithFormat:@"%@",appLogKey];
    self.page = [NSString stringWithFormat:@"%@",page];
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
        //以下是拨打电话逻辑
        NSURL *callUrl = [NSURL URLWithString:[@"tel:" stringByAppendingString:self.phoneNum]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:callUrl]];
    }
}

@end
