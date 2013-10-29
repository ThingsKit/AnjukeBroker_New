//
//  PropertyDetailCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyObject.h"

@interface PropertyDetailCell : UITableViewCell
{
    UILabel *title;
    UILabel *communityName;
    UILabel *price;
    UILabel *tapNum;
    UILabel *tapNumStr;
    
}
-(void)setValueForCellByObject:(PropertyObject *) obj;
@end
