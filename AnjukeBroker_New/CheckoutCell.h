//
//  CheckoutCell.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-13.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"

typedef NS_ENUM(NSInteger, CHECKOUTCELLTYPE) {
    CHECKOUTCELLWITHNOCHECK = 0,
    CHECKOUTCELLWITHCHCK,
    CHECKOUTCELLWITHELSE
};


@interface CheckoutCell : RTListCell
@property(nonatomic, assign) CHECKOUTCELLTYPE cellViewType;
@property(nonatomic, strong) UILabel *detailLab;
@property(nonatomic, strong) UIView *checkerInfo;

- (void)configurCell:(id)dataModel withIndex:(int)index cellType:(CHECKOUTCELLTYPE)cellType;
@end
