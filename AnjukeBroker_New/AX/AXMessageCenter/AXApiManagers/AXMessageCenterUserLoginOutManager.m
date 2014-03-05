//
//  AXMessageCenterUserLoginOutManager.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-3-2.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageCenterUserLoginOutManager.h"

@implementation AXMessageCenterUserLoginOutManager
- (NSString *)methodName
{
    return [NSString stringWithFormat:@"quit/%@/%@/%@",[[UIDevice currentDevice] udid],@"i-ajk",self.apiParams[@"uid"]];
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
