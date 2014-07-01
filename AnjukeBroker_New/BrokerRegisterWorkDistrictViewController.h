//
//  BrokerRegisterWorkAreaViewController.h
//  AnjukeBroker_New
//
//  Created by jason on 6/25/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "BrokerRegisterWorkBlockViewController.h"

@interface BrokerRegisterWorkDistrictViewController : RTViewController

@property(nonatomic) id<BrokerRegisterWorkRangeDelegate> delegate;
- (void)loadDistrictDataWithCityId:(NSString *)city;

@end
