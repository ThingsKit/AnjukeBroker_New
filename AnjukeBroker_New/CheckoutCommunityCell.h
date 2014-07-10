//
//  CheckoutCommunityCell.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"

@interface CheckoutCommunityCell : RTListCell
@property(nonatomic, strong) UILabel *checkStatusLab;

- (BOOL)configureCell:(id)dataModel withIndex:(int)index;
- (void)showCheckedStatus:(BOOL)checked;
@end
