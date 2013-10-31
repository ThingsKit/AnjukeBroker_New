//
//  AnjukePropertyGroupCell.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-30.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

#define PROPERTY_GROUP_CELL 65

@interface AnjukePropertyGroupCell : RTListCell

@property (nonatomic, strong) UILabel *groupNameLb;
@property (nonatomic, strong) UILabel *limitPriceLb;
@property (nonatomic, strong) UILabel *statusLb;

@end
