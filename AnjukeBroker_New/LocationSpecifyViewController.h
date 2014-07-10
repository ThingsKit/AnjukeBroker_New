//
//  LocationSpecifyViewController.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-25.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RTViewController.h"

@interface LocationSpecifyViewController : RTViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@end
