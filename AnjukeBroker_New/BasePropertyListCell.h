//
//  PropertyListCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePropertyObject.h"
#import "RTListCell.h"

@interface BasePropertyListCell : RTListCell
{
    UILabel *title;
    UILabel *communityName;
    UILabel *price;
    UILabel *tapNum;
    UILabel *tapNumStr;
}
-(void)setValueForCellByObject:(BasePropertyObject *) obj;

@end