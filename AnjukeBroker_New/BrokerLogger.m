//
//  BrokerLogger.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-26.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "BrokerLogger.h"
#import "LoginManager.h"

@implementation BrokerLogger

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static BrokerLogger *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[BrokerLogger alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)logWithActionCode:(NSString *)actionCode note:(NSDictionary *)note {
    [[RTLogger sharedInstance] setSelectedCityID:[LoginManager getCity_id]];
    [[RTLogger sharedInstance] setUserID:[LoginManager getUserID]];
    
    [[RTLogger sharedInstance] logWithActionCode:actionCode note:note];
}

@end
