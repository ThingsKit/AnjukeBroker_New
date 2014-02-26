//
//  AXMessageCenterSendMessageManager.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageCenterSendMessageManager.h"

@implementation AXMessageCenterSendMessageManager
- (NSString *)methodName
{
    return [NSString stringWithFormat:@"message/sendFriendMessage/%@/%@",self.apiParams[@"phone"],self.apiParams[@"to_uid"]];
}

-(RTAPIManagerRequestType )requestType
{
    return RTAPIManagerRequestTypeRestPost;
}
- (RTServiceType)serviceType
{
    return RTAnjukeXRESTServiceID;
}

#pragma mark - RTAPIManagerValidator
- (BOOL)manager:(RTAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return YES;
}

- (BOOL)manager:(RTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

#pragma mark - methods override
- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    self.apiParams[@"requestID"] = params[kRTAPIBaseManagerRequestID];
    [self.interceotorDelegate manager:self afterCallingAPIWithParams:params];
}

- (NSDictionary *)paramsForApi:(RTAPIBaseManager *)manager
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:self.apiParams];
    [params removeObjectForKey:@"phone"];
    if (![params[@"msg_type"] isEqualToString:@"1"] && ![params[@"msg_type"] isEqualToString:@"2"] ) {
        [params removeObjectForKey:@"body"];
        NSData *data = [self.apiParams[@"body"] dataUsingEncoding:NSUTF8StringEncoding];
        __autoreleasing NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        params[@"body"] = dic;
    }
    
    return params;
}
- (void)beforePerformFailWithResponse:(RTNetworkResponse *)response
{
    [self.interceotorDelegate manager:self beforePerformFailWithResponse:response];
}
- (void)beforePerformSuccessWithResponse:(RTNetworkResponse *)response
{
    [self.interceotorDelegate manager:self afterPerformSuccessWithResponse:response];
}
@end
