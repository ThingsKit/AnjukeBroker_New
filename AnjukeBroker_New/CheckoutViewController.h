//
//  CheckoutViewController.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import <MapKit/MapKit.h>


@interface CheckoutViewController : RTViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>

- (void)passCommunityDic:(NSDictionary *)dic;

@end
