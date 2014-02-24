//
//  AXMessageCenterUpdataPasswordManager.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageCenterUpdataPasswordManager.h"

@implementation AXMessageCenterUpdataPasswordManager
- (NSString *)methodName
{
    return [NSString stringWithFormat:@"user/modifyPasword/%@",self.apiParams[@"phone"]];
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
    return @{@"password": self.apiParams[@"password"]};
}
- (BOOL)manager:(RTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

@end
