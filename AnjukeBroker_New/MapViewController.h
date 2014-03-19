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

@protocol chooseSiteDelegate <NSObject>
-(void)returnSiteAttr:(double)lat lon:(double)lon address:(NSString *)address;
@end

typedef enum
{
    RegionChoose = 0,
    RegionNavi
}mapType;

@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIActionSheetDelegate>{
    CLLocationManager *locationManager;
}
@property(nonatomic,assign) id<chooseSiteDelegate> siteDelegate;
@property(nonatomic,assign) mapType mapType;
@property(nonatomic,assign) double lat;
@property(nonatomic,assign) double lon;
@property(nonatomic,strong) NSString *addressStr;
@property(nonatomic,assign) MKCoordinateRegion naviRegion;

-(void)navOption;
@end
