//
//  MapViewController.h
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLocationManager.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

typedef enum
{
    RegionChoose = 0,
    RegionNavi
}mapType;



@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}


@property(nonatomic,assign) mapType mapTypeIndex;
@property(nonatomic,strong) MKMapView *regionMapView;
@property(nonatomic,assign) int updateInt;
@property(nonatomic,assign) MKCoordinateRegion UserRegion;
@property(nonatomic,strong) CLLocation *lastloc;

@property(nonatomic,strong) CLLocation *navLoc;
@property(nonatomic,strong) NSString *addressStr;
@end
