//
//  NoPlanListCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/28/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTListCell.h"

@interface BaseNoPlanListCell : RTListCell
{
    UILabel *title;
    UILabel *communityName;
    UILabel *price;
    UIButton *mutableSelect;
}

@end
