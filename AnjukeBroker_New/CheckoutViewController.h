//
//  CheckoutViewController.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import <MapKit/MapKit.h>
#import "BaseTableStructViewController.h"
#import "CheckCommunityModel.h"

typedef NS_ENUM(NSInteger, CHECKBUTTONSTATUS) {
    CHECKBUTTONWITHNORMALSTATUS = 0,
    CHECKBUTTONWITHCHECKING,
    CHECKBUTTONWITHLOADING,
    CHECKBUTTONWITHCOUNTDOWN
};

@protocol checkoutSuccussDelegate <NSObject>

- (void)checkedSuccuss;

@end

@interface CheckoutViewController : BaseTableStructViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>
@property(nonatomic, assign) CHECKBUTTONSTATUS checkStatus;
@property(nonatomic, strong) id<checkoutSuccussDelegate> checkoutDelegate;
- (void)passCommunityWithModel:(CheckCommunityModel *)model;
- (void)timeCountZero;


@end
