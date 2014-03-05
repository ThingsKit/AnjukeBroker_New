//
//  AXMessageCenterUserLoginOutManager.h
//  Anjuke2
//
//  Created by 杨 志豪 on 14-3-2.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "RTAPIBaseManager.h"

@interface AXMessageCenterUserLoginOutManager : RTAPIBaseManager<RTAPIManagerParamSourceDelegate,RTAPIManagerValidator>
@property (nonatomic, strong) NSDictionary *apiParams;
@end
