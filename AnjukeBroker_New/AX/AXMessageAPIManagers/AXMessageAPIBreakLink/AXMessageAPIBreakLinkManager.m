//
//  AXMessageAPIBreakLink.m
//  Anjuke2
//
//  Created by casa on 14-3-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageAPIBreakLinkManager.h"
#import "AXMessageApiConfiguration.h"

@interface AXMessageAPIBreakLinkManager ()

@property (nonatomic, strong) ASIHTTPRequest *request;

@end

@implementation AXMessageAPIBreakLinkManager

#pragma mark - public methods
- (void)breakLinkWithUserId:(NSString *)userId
{
    NSString *cancelUrlString = [NSString stringWithFormat:@"%@/quit/%@/%@/%@/", kAXConnectManagerLinkParamHost, [[UIDevice currentDevice] udid], kAXConnectManagerLinkAppName, userId];
    
    if (self.request != nil) {
        [self.request cancel];
        self.request = nil;
    }
    
    self.request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[cancelUrlString appendURLCommonParams]]];
    self.request.validatesSecureCertificate = NO;
    self.request.delegate = self;
    self.request.shouldContinueWhenAppEntersBackground = YES;
    self.request.timeOutSeconds = kAXMessageManagerDefaultRequestTimeOutInterval;
    [self.request startSynchronous];
    DLog(@"BREAK LINK:%@", self.request.url);
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    //其实根本不care这个，不过先写在这儿了
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //其实根本不care这个，不过先写在这儿了
}

@end
