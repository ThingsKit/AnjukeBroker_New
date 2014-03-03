//
//  AXMessageCenterGetFriendInfoManager.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-26.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageCenterGetFriendInfoManager.h"

@implementation AXMessageCenterGetFriendInfoManager
- (NSString *)methodName
{
    return [NSString stringWithFormat:@"user/getFriendInfo/%@",self.apiParams[@"phone"]];
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
    return @{@"to_uids":self.apiParams[@"to_uids"]};
}
- (BOOL)manager:(RTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

@end
