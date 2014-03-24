//
//  AXMessageAPIBuildLink.h
//  Anjuke2
//
//  Created by casa on 14-3-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXMessageApiConfiguration.h"

@class AXMessageAPILongLinkManager;

@protocol AXMessageAPILongLinkDelegate <NSObject>
@required
// link status 这里没有关于连接失败的委托，是因为连接失败的时候会自动重试。
- (void)manager:(AXMessageAPILongLinkManager *)manager willConnectToServerAsUserType:(AXMessageAPILongLinkUserType)userType userId:(NSString *)userId;
- (void)manager:(AXMessageAPILongLinkManager *)manager didReceiveSignal:(AXMessageAPILongLinkSignal)signal
                                                               userType:(AXMessageAPILongLinkUserType)userType
                                                                 userId:(NSString *)userId
                                                               userInfo:(NSDictionary *)userInfo;
@end

@interface AXMessageAPILongLinkManager : NSObject

@property (nonatomic, copy, readonly) NSString *currentLoggedUserId;
@property (nonatomic, assign, readonly) AXMessageAPILongLinkUserType currentUserType;

// 在用户端如果被T出，则至少要保持一个连接，这个值应当设置成YES，如果是经纪人端，被T出后不需要保持连接，这个值应当是NO
@property (nonatomic, assign) BOOL shouldKeepAtLeastOneLink;

@property (nonatomic, weak) id<AXMessageAPILongLinkDelegate> delegate;

- (void)connectAsDevice;
- (void)connectAsUserWithUserid:(NSString *)userId;
- (void)breakLink;

@end
