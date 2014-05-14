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


@interface CheckoutViewController : BaseTableStructViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>

- (void)passCommunityDic:(NSDictionary *)dic;
- (void)timeCountZero;
- (void)doRequest;
@end
