//
//  AXMessageCenterSearchBrokerManager.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageCenterSearchBrokerManager.h"

@implementation AXMessageCenterSearchBrokerManager
- (NSString *)methodName
{
    return [NSString stringWithFormat:@"user/borkerSearch/%@",self.apiParams[@"brokerPhone"]];
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
