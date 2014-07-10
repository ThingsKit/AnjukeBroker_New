//
//  UpdateUserLocation.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-26.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "RTRequestProxy.h"

@interface UpdateUserLocation : NSObject<MKMapViewDelegate>

+ (UpdateUserLocation *)shareUpdateUserLocation;

- (void)fetchUserLocationWithComeletionBlock:(void(^)(BOOL updateLocationIsOk))completionBlock;

@property(nonatomic, strong) void (^complecation)(BOOL updateLocationIsOk);
@property(nonatomic, assign) BOOL isRequestIng;
@end
