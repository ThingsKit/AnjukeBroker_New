//
//  AXMessageCenterPublicServiceActionEventManager.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AXMessageCenterPublicServiceActionEventManager.h"

@implementation AXMessageCenterPublicServiceActionEventManager

- (NSString *)methodName
{
    return [NSString stringWithFormat:@"mobile/v5/weiliao/service/%@/action/%@",self.apiParams[@"service_id"],self.apiParams[@"action_id"]];
}

- (RTServiceType)serviceType
{
    return RTAnjukeXPublicServiceRESTServiceID;
}

- (RTAPIManagerRequestType)requestType
{
    return RTAPIManagerRequestTypeRestGet;
}

#pragma mark - RTAPIManagerValidator
- (BOOL)manager:(RTAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return YES;
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
