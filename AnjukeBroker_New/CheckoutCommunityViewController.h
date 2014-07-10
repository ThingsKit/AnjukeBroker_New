//
//  CheckoutCommunityViewController.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTViewController.h"
#import <MapKit/MapKit.h>
#import "BaseTableStructViewController.h"

@interface CheckoutCommunityViewController : BaseTableStructViewController<MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate>

@end
