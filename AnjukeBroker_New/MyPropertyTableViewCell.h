//
//  MyPropertyTableViewCell.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-14.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTListCell.h"

@class MyPropertyModel;
@interface MyPropertyTableViewCell : RTListCell <UIActionSheetDelegate, UIWebViewDelegate>

@property (nonatomic, retain) MyPropertyModel* myPropertyModel;

@end
