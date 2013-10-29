//
//  PPCGroupCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPCGroupCell : UITableViewCell
{
    UILabel *title;
    UILabel *detail;
    UILabel *status;
}
-(void)setValueForCellByDictinary:(NSDictionary *) dic;
@end
