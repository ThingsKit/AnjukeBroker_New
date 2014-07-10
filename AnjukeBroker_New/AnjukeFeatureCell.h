//
//  AnjukeFeatureCell.h
//  AnjukeBroker_New
//
//  Created by paper on 14-4-21.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"

#define FEATURE_CELL_HEIGHT 50

@interface AnjukeFeatureCell : RTListCell

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIImageView *clickImg;

- (void)configureCellStatus:(BOOL)isClick;
@end
