//
//  SaleNoPlanListCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/30/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseNoPlanListCell.h"

@protocol CheckmarkBtnClickDelegate <NSObject>

- (void)checkmarkBtnClickedWithRow:(int)row;

@end

@interface SaleNoPlanListCell : BaseNoPlanListCell

@property (strong, nonatomic) UIButton *mutableBtn;
@property (strong, nonatomic) UIImageView *btnImage;
@property (nonatomic, assign) id <CheckmarkBtnClickDelegate> clickDelegate;

@end
