//
//  UserCenterHeaderCell.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-6.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

@interface UserCenterHeaderCell : RTListCell
@property(nonatomic, strong) UIButton * userLevelBtn;
@property(nonatomic, strong) UILabel * userLeftMoney;


- (void)updateUserHeaderInfo:(BOOL)isSDX leftMoney:(NSString *)leftMoney;
@end
