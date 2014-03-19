//
//  RegionAnnotationView.h
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-19.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface RegionAnnotationView : MKAnnotationView
@property(nonatomic,strong) UIView *regionDetailView;
//@property(nonatomic,strong) UIView *loadingView;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)animateCalloutAppearance;

@end
