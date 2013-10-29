//
//  FixedDetailCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FixedObject.h"

@interface FixedDetailCell : UITableViewCell
{
    UILabel *tapNum;
    UILabel *totalCost;
    UILabel *topCost;
    UILabel *tapNumStr;
    UILabel *totalCostStr;
    UILabel *topCostStr;
}
-(void)setValueForCellByObject:(FixedObject *) obj;
@end
