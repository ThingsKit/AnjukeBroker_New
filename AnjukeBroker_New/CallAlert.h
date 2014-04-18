//
//  CallAlert.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallAlert : NSObject<UIAlertViewDelegate>


+ (CallAlert *) sharedCallAlert;
- (void)callAlert:(NSString *)alertStr callPhone:(NSString *)callPhone;
@end
