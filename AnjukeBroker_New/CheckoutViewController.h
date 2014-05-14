//
//  CheckoutViewController.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import <MapKit/MapKit.h>
#import "BaseTableStructViewController.h"
#import "CheckCommunityModel.h"

@interface CheckoutViewController : BaseTableStructViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>

- (void)passCommunityWithModel:(CheckCommunityModel *)model;
- (void)timeCountZero;

@end
