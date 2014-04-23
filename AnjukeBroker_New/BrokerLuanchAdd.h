//
//  BrokerLuanchAdd.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-23.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrokerLuanchAdd : NSObject
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) UIImageView *launchAddView;

+ (BrokerLuanchAdd *) sharedLuanchAdd;
- (void)doRequst;
@end
