//
//  PropertyEditViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-29.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishBuildingViewController.h"

@protocol PropertyEditDelegate <NSObject>

- (void)propertyDidDelete;

@end

@interface PropertyEditViewController : PublishBuildingViewController

@property (nonatomic, copy) NSString *propertyID;
@property (nonatomic, assign) id <PropertyEditDelegate> propertyDelegate;

@end
