//
//  RTAPIManagerInterceptorProtocal.h
//  AnjukeHD
//
//  Created by casa on 14-1-15.
//  Copyright (c) 2014年 Anjuke Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTAPIBaseManager.h"

@protocol RTAPIManagerInterceptorProtocal <NSObject>

@optional
- (void)manager:(RTAPIBaseManager *)manager beforePerformSuccessWithResponse:(RTNetworkResponse *)response;
- (void)manager:(RTAPIBaseManager *)manager afterPerformSuccessWithResponse:(RTNetworkResponse *)response;

- (void)manager:(RTAPIBaseManager *)manager beforePerformFailWithResponse:(RTNetworkResponse *)response;
- (void)manager:(RTAPIBaseManager *)manager afterPerformFailWithResponse:(RTNetworkResponse *)response;

- (void)manager:(RTAPIBaseManager *)manager beforeCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(RTAPIBaseManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end
