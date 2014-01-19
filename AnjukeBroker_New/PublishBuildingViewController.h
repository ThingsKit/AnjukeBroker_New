//
//  PublishBuildingViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "Util_UI.h"
#import "PublishTextCell.h"

@interface PublishBuildingViewController : RTViewController <UIScrollViewDelegate>

@property BOOL isHaozu; //是否是好租，页面布局不同
@property (nonatomic, strong) UIScrollView *mainScrollView;

@end
