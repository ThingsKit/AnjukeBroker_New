//
//  BrokerLuanchAdd.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-23.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXIMGDownloader.h"

@interface BrokerLuanchAdd : NSObject
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) UIImageView *launchAddView;
@property(nonatomic, strong) AXIMGDownloader *imgDownloader;
@property(nonatomic, strong) NSDictionary *lauchAddDic;
@property(nonatomic, strong) NSDictionary *lauchConfig;

+ (BrokerLuanchAdd *) sharedLuanchAdd;
- (void)doRequst;
@end
