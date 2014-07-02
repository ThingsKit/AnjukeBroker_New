//
//  BrokerRegisterWorkCityViewController.h
//  AnjukeBroker_New
//
//  Created by jason on 6/25/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@protocol BrokerRegisterWorkCityDelegate <NSObject>

- (void)didSelectCity:(NSDictionary *)city;

- (void)canceledCitySelection;

@end

@interface BrokerRegisterWorkCityViewController : RTViewController

@property(nonatomic) id<BrokerRegisterWorkCityDelegate> delegate;

@end
