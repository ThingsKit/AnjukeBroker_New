//
//  AnjukePropertyGroupCell.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-30.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

#define PROPERTY_GROUP_CELL 65

#define STATUS_STOP_ICON [UIImage imageNamed:@"anjuke_icon09_stop.png"]
#define STATUS_OK_ICON [UIImage imageNamed:@"anjuke_icon09_woking.png"]
#define STATUS_ATTENTION_ICON [UIImage imageNamed:@"anjuke_icon08_attention.png"]

@interface AnjukePropertyGroupCell : RTListCell

@property (nonatomic, strong) UILabel *groupNameLb;
@property (nonatomic, strong) UILabel *limitPriceLb;
@property (nonatomic, strong) UIImageView *statusIcon;

- (BOOL)configureCell:(id)dataModel withTitle:(NSString *)title;

@end
