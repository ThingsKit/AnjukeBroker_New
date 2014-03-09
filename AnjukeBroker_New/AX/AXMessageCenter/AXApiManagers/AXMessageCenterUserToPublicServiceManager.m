//
//  AXMessageCenterUserToPublicServiceManager.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-3-5.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageCenterUserToPublicServiceManager.h"

@implementation AXMessageCenterUserToPublicServiceManager
- (NSString *)methodName
{
    return [NSString stringWithFormat:@"message/publicservice/feedbackByUser/%@",self.apiParams[@"phone"]];
}

- (RTServiceType)serviceType
{
    return RTAnjukeXRESTServiceID;
}
- (RTAPIManagerRequestType)requestType
{
    return RTAPIManagerRequestTypeRestPost;
}

#pragma mark - RTAPIManagerValidator
- (BOOL)manager:(RTAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return YES;
}

- (NSDictionary *)paramsForApi:(RTAPIBaseManager *)manager
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:self.apiParams];
    [params removeObjectForKey:@"phone"];
    return params;
}

- (BOOL)manager:(RTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    self.apiParams[@"requestID"] = params[kRTAPIBaseManagerRequestID];
    [self.interceotorDelegate manager:self afterCallingAPIWithParams:params];
}

- (void)beforePerformFailWithResponse:(RTNetworkResponse *)response
{
    [self.interceotorDelegate manager:self beforePerformFailWithResponse:response];
}
- (void)beforePerformSuccessWithResponse:(RTNetworkResponse *)response
{
    [self.interceotorDelegate manager:self afterPerformSuccessWithResponse:response];
}

@end
