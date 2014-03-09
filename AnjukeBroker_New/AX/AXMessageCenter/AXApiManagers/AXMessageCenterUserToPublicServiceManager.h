//
//  AXMessageCenterUserToPublicServiceManager.h
//  Anjuke2
//
//  Created by 杨 志豪 on 14-3-5.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "RTAPIBaseManager.h"
#import "RTAPIManagerInterceptorProtocal.h"

@interface AXMessageCenterUserToPublicServiceManager : RTAPIBaseManager<RTAPIManagerParamSourceDelegate,RTAPIManagerValidator>
@property (nonatomic, weak) id<RTAPIManagerInterceptorProtocal> interceotorDelegate;
@property (nonatomic, strong) NSMutableDictionary *apiParams;
@end
