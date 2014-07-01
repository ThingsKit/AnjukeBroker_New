//
//  BrokerRegisterWorkPlateViewController.h
//  AnjukeBroker_New
//
//  Created by jason on 6/25/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@protocol BrokerRegisterWorkRangeDelegate <NSObject>

- (void)didSelectWorkRange:(NSDictionary *)workRangeDic;

@end

@interface BrokerRegisterWorkBlockViewController : RTViewController


@property (nonatomic,assign) id<BrokerRegisterWorkRangeDelegate> delegate;

- (void) loadBlockDataWithDistrict:(NSDictionary *)district;

@end
