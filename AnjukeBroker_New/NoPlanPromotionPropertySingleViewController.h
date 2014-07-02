//
//  NoPlanPromotionPropertySingleViewController.h
//  AnjukeBroker_New
//
//  Created by jason on 7/1/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "PropertyEditViewController.h"

@interface NoPlanPromotionPropertySingleViewController : RTViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, assign) id <PropertyEditDelegate> propertyDelegate;

@end
