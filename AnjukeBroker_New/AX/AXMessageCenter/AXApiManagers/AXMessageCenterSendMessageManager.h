//
//  AXMessageCenterSendMessageManager.h
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "RTAPIBaseManager.h"
#import "RTAPIManagerInterceptorProtocal.h"

@interface AXMessageCenterSendMessageManager : RTAPIBaseManager<RTAPIManagerValidator, RTAPIManagerParamSourceDelegate>
@property (nonatomic, weak) id<RTAPIManagerInterceptorProtocal> interceotorDelegate;
@property (nonatomic, strong) NSMutableDictionary *apiParams;
@end
