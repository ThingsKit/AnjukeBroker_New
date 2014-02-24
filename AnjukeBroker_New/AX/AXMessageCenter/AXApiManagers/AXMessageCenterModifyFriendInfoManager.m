//
//  AXMessageCenterModifyFriendInfoManager.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-20.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageCenterModifyFriendInfoManager.h"

@implementation AXMessageCenterModifyFriendInfoManager
- (NSString *)methodName
{
    return [NSString stringWithFormat:@"user/modifyFriendInfo/%@",self.apiParams[@"phone"]];
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
    NSDictionary *params = @{
                             @"mark_name":self.apiParams[@"mark_name"],
                             @"to_uid":self.apiParams[@"to_uid"],
                             @"is_star":self.apiParams[@"is_star"],
                             @"relation_cate_id":self.apiParams[@"relation_cate_id"]
                             };
    return params;
}
- (BOOL)manager:(RTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

@end
