//
//  CallAlert.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-18.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrokerCallAlert : NSObject<UIWebViewDelegate>


+ (BrokerCallAlert *) sharedCallAlert;
- (void)callAlert:(NSString *)alertStr callPhone:(NSString *)callPhone appLogKey:(NSString *)appLogKey page:(NSString *)page completion:(void (^)(CFAbsoluteTime time))completion;

@end
