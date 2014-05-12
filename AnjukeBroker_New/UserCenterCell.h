//
//  UserCenterCell.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

@interface UserCenterCell : RTListCell

- (void)initLabelTitle:(NSString *)title;
- (void)setDetailText:(NSString *)detailStr;
- (void)showTightIcon;

@end
