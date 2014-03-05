//
//  AXMessageCenterAppGetAllMessageManager.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-3-5.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageCenterAppGetAllMessageManager.h"

@implementation AXMessageCenterAppGetAllMessageManager
- (NSString *)methodName
{
    return [NSString stringWithFormat:@"message/app/getAllNewMessages/%@/%@/%@",self.apiParams[@"to_device_id"],self.apiParams[@"to_app_name"],self.apiParams[@"last_max_msg_id"]];
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
