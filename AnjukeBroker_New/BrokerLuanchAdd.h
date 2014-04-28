//
//  BrokerLuanchAdd.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-23.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXIMGDownloader.h"

@interface BrokerLuanchAdd : NSObject
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) UIImageView *launchAddView;
@property(nonatomic, strong) AXIMGDownloader *imgDownloader;
+ (BrokerLuanchAdd *) sharedLuanchAdd;
- (void)doRequst;
@end
