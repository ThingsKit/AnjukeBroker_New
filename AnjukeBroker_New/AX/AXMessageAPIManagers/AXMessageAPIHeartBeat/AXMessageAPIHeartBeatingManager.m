//
//  AXMessageAPIHeartBeat.m
//  Anjuke2
//
//  Created by casa on 14-3-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageAPIHeartBeatingManager.h"
#import "AXMessageApiConfiguration.h"

@interface AXMessageAPIHeartBeatingManager ()

@property (nonatomic, strong) ASIHTTPRequest *request;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy, readwrite) NSString *userId;

@end

@implementation AXMessageAPIHeartBeatingManager

#pragma mark - getters and setters
- (NSString *)userId
{
    _userId = [self.paramSource userIdForHeartBeatingManager:self];
    if (_userId == nil) {
        _userId = @"0";
    }
    return _userId;
}

#pragma mark - public methods
- (void)startHeartBeat
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.timer.isValid) {
            [self.timer invalidate];
        }
        
        self.timer = [NSTimer timerWithTimeInterval:kAXMessageManagerLongLinkHeartBeatingInterval target:self selector:@selector(beating) userInfo:nil repeats:YES];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [runLoop run];
    });
}

- (void)stopHeartBeat
{
    [self.timer invalidate];
}

#pragma mark - private methods
- (void)beating
{
    if (self.request != nil) {
        [self.request cancel];
        self.request = nil;
    }
    
    NSString *heartBeatingUrlString = [NSString stringWithFormat:@"%@/ping/%@/%@/%@/", kAXConnectManagerLinkParamHost, [[UIDevice currentDevice] udid], kAXConnectManagerLinkAppName, self.userId];
    self.request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[heartBeatingUrlString appendURLCommonParams]]];
    DLog(@"HEART BEATING %@", self.request.url);
    self.request.delegate = self;
    self.request.shouldContinueWhenAppEntersBackground = NO;
    self.request.validatesSecureCertificate = NO;
    self.request.timeOutSeconds = kAXMessageManagerDefaultRequestTimeOutInterval;
    [self.request startSynchronous];
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
