//
//  DiscoverViewController.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@interface DiscoverViewController : RTViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView* badgeView;
@property (nonatomic, strong) UILabel* badgeNumberLabel;

- (void)setDiscoverBadgeValue:(NSInteger) unReadCount;

@end
