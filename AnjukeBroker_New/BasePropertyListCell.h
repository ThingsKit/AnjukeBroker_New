//
//  PropertyListCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalePropertyObject.h"
#import "RTListCell.h"

@interface BasePropertyListCell : RTListCell
{

}
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *comName;
@property (strong, nonatomic) UILabel *detail;
@property (strong, nonatomic) UILabel *price;
@property (strong, nonatomic) UILabel *tapNum;
@property (strong, nonatomic) UILabel *tapNumStr;
@property (strong, nonatomic) UIImageView *bidStatue;

-(void)setValueForCellByObject:(SalePropertyObject *) obj;

@end
