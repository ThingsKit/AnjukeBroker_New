//
//  MyPropertyTableViewCell.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-14.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@class MyPropertyModel;
@interface MyPropertyTableViewCell : UITableViewCell <RTLabelDelegate>

@property (nonatomic, retain) MyPropertyModel* myPropertyModel;

@end
