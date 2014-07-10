//
//  PPCHouseCell.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-1.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"
#import "SWTableViewCell.h"
#import "BrokerLineView.h"

@interface PPCHouseCell : SWTableViewCell

@property (strong, nonatomic) BrokerLineView *lineView;
@property (strong, nonatomic) BrokerLineView *topLine;

- (BOOL)configureCell:(id)dataModel withIndex:(int)index isHaoZu:(BOOL)isHaoZu;
- (void)showBottonLineWithCellHeight:(CGFloat)cellH andOffsetX:(CGFloat)offsetX;
- (void)showTopLine;
@end
