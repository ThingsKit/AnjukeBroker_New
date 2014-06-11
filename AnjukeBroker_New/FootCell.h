//
//  FootCell.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-11.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

typedef NS_ENUM (NSUInteger, FootCellStatus)
{
    FootCellStatusForNormal = 0,
    FootCellStatusForRefresh = 1,
    FootCellStatusForLoadSuc = 2,
    FootCellStatusForNetWorkError = 3,
    FootCellStatusForLoadFail = 4
};

@interface FootCell : RTListCell

@property(nonatomic, assign) FootCellStatus cellStatus;
@property(nonatomic, strong) UILabel *tipsLab;
@property(nonatomic, strong) UIActivityIndicatorView *activeRefresh;
@end
