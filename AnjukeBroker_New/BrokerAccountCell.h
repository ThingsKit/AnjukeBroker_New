//
//  BrokerAccountCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/26/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

@interface BrokerAccountCell : RTListCell
@property (strong, nonatomic) UILabel *labKey;
@property (strong, nonatomic) UILabel *labValue;
@property (strong, nonatomic) UIImageView *img;
- (BOOL)configureCell:(id)dataModel withIndex:(int)index;
@end
