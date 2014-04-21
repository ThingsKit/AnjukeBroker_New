//
//  MoreListCell.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-1.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

#define MORE_CELL_H 96/2

@interface MoreListCell : RTListCell

@property (nonatomic, strong) UISwitch *messageSwtich;
@property (nonatomic, strong) UILabel *detailLb;

//- (void)showSwitch:(BOOL)isMsgOpen;
- (void)setDetailText:(NSString *)string;

@end
