//
//  MyPropertyTableViewCell.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-14.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyPropertyModel;
@interface MyPropertyTableViewCell : UITableViewCell <UIActionSheetDelegate>

@property (nonatomic, retain) MyPropertyModel* myPropertyModel;

@end
