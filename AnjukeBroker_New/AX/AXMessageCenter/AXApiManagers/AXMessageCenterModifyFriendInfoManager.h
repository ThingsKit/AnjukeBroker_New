//
//  AXMessageCenterModifyFriendInfoManager.h
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-20.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "RTAPIBaseManager.h"

@interface AXMessageCenterModifyFriendInfoManager : RTAPIBaseManager<RTAPIManagerParamSourceDelegate,RTAPIManagerValidator>
@property (nonatomic, strong) NSMutableDictionary *apiParams;

@end
