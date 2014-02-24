//
//  AXMessageCenterReceiveMessageManager.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageCenterReceiveMessageManager.h"

@implementation AXMessageCenterReceiveMessageManager
- (NSString *)methodName
{
    return [NSString stringWithFormat:@"message/getAllNewMessages/%@/%@",self.apiParams[@"phone"],self.apiParams[@"last_max_msgid"]];
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
     return @{@"body":@"here i am"};
}
- (BOOL)manager:(RTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}


@end
