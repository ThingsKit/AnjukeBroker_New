//
//  PropertyResetViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-19.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukeEditPropertyViewController.h"

@protocol PropertyDeleteDelegate <NSObject>

- (void)propertyDidDelete;

@end

@interface PropertyResetViewController : AnjukeEditPropertyViewController

@property (nonatomic, copy) NSString *propertyID;
@property (nonatomic, assign) id <PropertyDeleteDelegate> propertyDelegate;

@end
