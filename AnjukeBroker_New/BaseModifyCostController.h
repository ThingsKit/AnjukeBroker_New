//
//  BaseModifyCostController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/19/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "FixedObject.h"

@interface BaseModifyCostController : RTViewController
@property (strong, nonatomic) FixedObject *fixedObject;
@property (strong, nonatomic) UITextField *totalCost;
@end
