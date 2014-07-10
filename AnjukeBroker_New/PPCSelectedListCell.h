//
//  PPCSelectedListCell.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-2.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"

@interface PPCSelectedListCell : RTListCell
- (BOOL)configureCell:(id)dataModel withIndex:(int)index isHaoZu:(BOOL)isHaoZu;
@end
