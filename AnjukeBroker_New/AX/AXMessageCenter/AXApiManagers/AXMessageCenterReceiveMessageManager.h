//
//  AXMessageCenterReceiveMessageManager.h
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "RTAPIBaseManager.h"

@interface AXMessageCenterReceiveMessageManager : RTAPIBaseManager<RTAPIManagerValidator, RTAPIManagerParamSourceDelegate>
@property (nonatomic, strong) NSDictionary *apiParams;
@property (nonatomic, copy) NSString *uniqLongLinkId;
@end
