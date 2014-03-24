//
//  AXMessageCenterDownLoadAudioManager.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-3-20.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageCenterDownLoadAudioManager.h"

@implementation AXMessageCenterDownLoadAudioManager
- (NSString *)methodName
{
    return [NSString stringWithFormat:@"common/downloadFile/%@",self.apiParams[@"brokerInfo"]];
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
