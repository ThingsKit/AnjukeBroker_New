//
//  PPCPlanIdRequest.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-7.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTRequestProxy.h"

typedef enum : NSUInteger {
    RequestStatusForOk = 0,
    RequestStatusForNetWorkError,
    RequestStatusForNetRemoteServerError,
} RequestStatus;

@interface PPCPlanIdRequest : NSObject

@property(nonatomic, assign) RequestStatus status;

+ (PPCPlanIdRequest *) sharePlanIdRequest;

- (void)getPricingPlanId:(BOOL)isHaoZu returnInfo:(void(^)(NSString *planId, RequestStatus status))sendPlanIdBlock;

@end
