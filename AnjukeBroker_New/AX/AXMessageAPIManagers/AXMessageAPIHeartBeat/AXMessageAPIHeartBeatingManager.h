//
//  AXMessageAPIHeartBeat.h
//  Anjuke2
//
//  Created by casa on 14-3-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AXMessageAPIHeartBeatingManagerParamSource <NSObject>

@required
- (NSString *)userIdForHeartBeatingManager:(id)manager;

@end

@interface AXMessageAPIHeartBeatingManager : NSObject

@property (nonatomic, copy, readonly) NSString *userId;

@property (nonatomic, weak) id<AXMessageAPIHeartBeatingManagerParamSource> paramSource;

- (void)startHeartBeat;
- (void)stopHeartBeat;

@end
