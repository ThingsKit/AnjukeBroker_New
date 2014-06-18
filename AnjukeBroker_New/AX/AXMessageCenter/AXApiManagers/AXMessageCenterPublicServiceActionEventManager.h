//
//  AXMessageCenterPublicServiceActionEventManager.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTAPIBaseManager.h"

@interface AXMessageCenterPublicServiceActionEventManager : RTAPIBaseManager<RTAPIManagerValidator,RTAPIManagerParamSourceDelegate>

@property (nonatomic, strong) NSDictionary *apiParams;

@end
