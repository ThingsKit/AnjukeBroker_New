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
#import "RegionAnnotationView.h"

@protocol MapViewControllerDelegate <NSObject>
@required
-(void)loadMapSiteMessage:(NSDictionary *)mapSiteDic;
@end

typedef enum
{
    RegionChoose = 0,
    RegionNavi
}mapType;

@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIActionSheetDelegate,doAcSheetDelegate>{
    CLLocationManager *locationManager;
}
@property(nonatomic,assign) id<MapViewControllerDelegate> siteDelegate;
@property(nonatomic,assign) mapType mapType;
@property(nonatomic,assign) double lat;
@property(nonatomic,assign) double lon;
@property(nonatomic,strong) NSString *addressStr;
@property(nonatomic,assign) MKCoordinateRegion naviRegion;

-(void)navOption;
@end
