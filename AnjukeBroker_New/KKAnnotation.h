//
//  KKAnnotation.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-25.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface KKAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
