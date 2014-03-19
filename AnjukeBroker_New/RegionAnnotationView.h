//
//  RegionAnnotationView.h
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-19.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <MapKit/MapKit.h>

@protocol doAcSheetDelegate <NSObject>
-(void)doAcSheet;
@end

@interface RegionAnnotationView : MKAnnotationView
@property(nonatomic,strong) UIView *regionDetailView;
@property(nonatomic,assign) id<doAcSheetDelegate>acSheetDelegate;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)animateCalloutAppearance;

@end
