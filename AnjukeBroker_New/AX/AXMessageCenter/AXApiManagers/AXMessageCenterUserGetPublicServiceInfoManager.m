//
//  AXMessageCenterUserGetPublicServiceInfoManager.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-3-5.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageCenterUserGetPublicServiceInfoManager.h"

@implementation AXMessageCenterUserGetPublicServiceInfoManager
- (NSString *)methodName
{
    return [NSString stringWithFormat:@"user/getPublicServiceInfo/%@",self.apiParams[@"service_id"]];
}

- (RTServiceType)serviceType
{
    return RTAnjukeXRESTServiceID;
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
    return @{};
}

- (BOOL)manager:(RTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}
@end
