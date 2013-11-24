//
//  PropertyDetailCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePropertyObject.h"

@interface PropertyDetailCell : UITableViewCell
{

}
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *detail;
@property (strong, nonatomic) UILabel *price;
@property (strong, nonatomic) UIButton *mutableSelect;
@property (strong, nonatomic) UIImageView *proIcon;
@property (strong, nonatomic) UIView *backView;

-(void)setValueForCellByObject:(BasePropertyObject *) obj;
-(void)setValueForCellByDictionar:(NSDictionary *) dic;

@end
