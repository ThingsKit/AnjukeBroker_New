//
//  MapViewController.h
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-18.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLocationManager.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "RegionAnnotationView.h"
#import "RTViewController.h"

@protocol MapViewControllerDelegate <NSObject>
@required
-(void)loadMapSiteMessage:(NSDictionary *)mapSiteDic;
@end

typedef enum{
    RegionChoose = 0,
    RegionNavi
}mapType;

@interface MapViewController : RTViewController<MKMapViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,CLLocationManagerDelegate,doAcSheetDelegate>{
    CLLocationManager *locationManager;
}

@property(nonatomic,assign) id<MapViewControllerDelegate> siteDelegate;
@property(nonatomic,assign) mapType mapType;
@property(nonatomic,strong) NSDictionary *navDic;
-(void)naviClick;
@end
