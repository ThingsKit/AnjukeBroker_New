//
//  AXMessageCenterGetUserOldMessageManager.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageCenterGetUserOldMessageManager.h"

@implementation AXMessageCenterGetUserOldMessageManager
- (NSString *)methodName
{
    return [NSString stringWithFormat:@"message/getUserOldMessages/%@/%@/%@",self.apiParams[@"phone"],self.apiParams[@"from_uid"],self.apiParams[@"top_min_msg_id"]];
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
    NSDictionary *params = self.apiParams[@"msg_ids"];
    return params;
    
}
- (BOOL)manager:(RTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}
@end
