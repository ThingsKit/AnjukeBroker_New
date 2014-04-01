//
//  AXNetWorkResponse.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 3/31/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "RTNetworkResponse.h"
#import "AXMappedMessage.h"

@interface AXNetWorkResponse : NSObject

@property (nonatomic, strong) NSString *identify;
@property (nonatomic, strong) AXMappedMessage *message;
@property (nonatomic, strong) RTNetworkResponse *response;
@property (nonatomic, assign) int sendStatus;
@property (nonatomic, assign) RTRequestID requestID;
- (id)init;
@end
