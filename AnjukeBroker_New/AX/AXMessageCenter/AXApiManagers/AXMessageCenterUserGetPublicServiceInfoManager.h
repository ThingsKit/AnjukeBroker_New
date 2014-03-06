//
//  AXMessageCenterUserGetPublicServiceInfoManager.h
//  Anjuke2
//
//  Created by 杨 志豪 on 14-3-5.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "RTAPIBaseManager.h"

@interface AXMessageCenterUserGetPublicServiceInfoManager : RTAPIBaseManager<RTAPIManagerParamSourceDelegate,RTAPIManagerValidator>
@property (nonatomic, strong) NSDictionary *apiParams;
@end
