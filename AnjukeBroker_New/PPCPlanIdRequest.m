//
//  PPCPlanIdRequest.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-7.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "PPCPlanIdRequest.h"
#import "LoginManager.h"
#import "Reachability.h"

static PPCPlanIdRequest *defaultPPCRequest;

@interface PPCPlanIdRequest ()
@property (nonatomic, strong) void (^sendPlanIdBlock)(NSString *planId, RequestStatus status);
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation PPCPlanIdRequest

+ (PPCPlanIdRequest *) sharePlanIdRequest{
    @synchronized(self){
        if (defaultPPCRequest == nil) {
            defaultPPCRequest = [[PPCPlanIdRequest alloc] init];
        }
        return defaultPPCRequest;
    }
}


- (void)getPricingPlanId:(BOOL)isHaoZu returnInfo:(void(^)(NSString *planId, RequestStatus status))sendPlanIdBlock{
    [self cancelRequest];
    
    _sendPlanIdBlock = sendPlanIdBlock;
    
    if (![self isNetworkOkayWithNoInfo]) {
        _sendPlanIdBlock(@"",RequestStatusForNetWorkError);
        return;
    }
    
    self.isLoading = YES;
    
    if (isHaoZu) {
        NSMutableDictionary *requeseParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId",[LoginManager getCity_id],@"cityId", nil];
        NSString *method = @"zufang/fix/summary/";

        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:requeseParams target:self action:@selector(onRequestFinished:)];
    }else{
        NSMutableDictionary *requeseParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId",[LoginManager getCity_id],@"cityId", nil];
        NSString *method = @"anjuke/fix/summary/";

        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:requeseParams target:self action:@selector(onRequestFinished:)];
    }
}
- (void)onRequestFinished:(RTNetworkResponse *)response{
    DLog(@"response---->>%@",[response content]);
    self.isLoading = NO;
    if(([[response content] count] == 0) || ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"])){
        _sendPlanIdBlock(@"",RequestStatusForNetRemoteServerError);
        
        return;
    }
    
    if ([[[response content] objectForKey:@"status"] isEqualToString:@"ok"] && [[response content] objectForKey:@"data"] && [[[response content] objectForKey:@"data"] objectForKey:@"planId"]) {
        NSString *planId = [[[response content] objectForKey:@"data"] objectForKey:@"planId"];
        _sendPlanIdBlock(planId,RequestStatusForOk);
    }else{
        _sendPlanIdBlock(@"",RequestStatusForNetRemoteServerError);
    }
}

- (void)cancelRequest
{
    if (self.isLoading) {
        [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
        self.isLoading = NO;
    }
}

- (BOOL)isNetworkOkayWithNoInfo {
    if (![[RTApiRequestProxy sharedInstance] isInternetAvailiable]) {
        return NO;
    }
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([r currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    
    return YES;
}
@end
