//
//  AXMessageCenterSendPropManager.h
//  AnjukeBroker_New
//
//  Created by anjuke on 14-6-24.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTAPIBaseManager.h"
#import "RTAPIManagerInterceptorProtocal.h"

@interface AXMessageCenterSendPropManager : RTAPIBaseManager<RTAPIManagerValidator,RTAPIManagerParamSourceDelegate>
@property (nonatomic, strong) NSMutableDictionary *apiParams;
@property (nonatomic, weak) id<RTAPIManagerInterceptorProtocal> interceotorDelegate;
@end
