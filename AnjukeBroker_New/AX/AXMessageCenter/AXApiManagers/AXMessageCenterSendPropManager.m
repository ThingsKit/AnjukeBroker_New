//
//  AXMessageCenterSendPropManager.m
//  AnjukeBroker_New
//
//  Created by anjuke on 14-6-24.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AXMessageCenterSendPropManager.h"

@implementation AXMessageCenterSendPropManager
- (NSString *)methodName
{
    return @"customer/sendprop/";
}

- (RTServiceType)serviceType
{
    return RTBrokerRESTServiceID;
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

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    self.apiParams[@"requestID"] = params[kRTAPIBaseManagerRequestID];
    [self.interceotorDelegate manager:self afterCallingAPIWithParams:params];
}

- (NSDictionary *)paramsForApi:(RTAPIBaseManager *)manager
{
    return self.apiParams;
}

- (BOOL)manager:(RTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

@end
