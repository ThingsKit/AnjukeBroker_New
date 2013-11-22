//
//  NoPlanListCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/28/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTListCell.h"
#import "BasePropertyObject.h"

@interface BaseNoPlanListCell : RTListCell
{

}
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *detail;
@property (strong, nonatomic) UILabel *price;
@property (strong, nonatomic) UIButton *mutableSelect;
@property (strong, nonatomic) UIImageView *proIcon;
@end
