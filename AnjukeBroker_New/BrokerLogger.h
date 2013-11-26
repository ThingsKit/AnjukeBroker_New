//
//  BrokerLogger.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-26.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrokerLogger : NSObject

- (void)logWithActionCode:(NSString *)actionCode note:(NSDictionary *)note;
+ (id)sharedInstance;

@end
