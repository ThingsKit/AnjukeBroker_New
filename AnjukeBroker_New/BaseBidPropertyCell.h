//
//  BidPropertyListCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BasePropertyListCell.h"
#import "RTListCell.h"

@interface BaseBidPropertyCell : RTListCell
{
    
}
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *price;
@property (strong, nonatomic) UILabel *string;
@property (strong, nonatomic) UILabel *stringNum;
@property (strong, nonatomic) UILabel *stage;
@property (strong, nonatomic) UIImageView *statusImg;
-(void)setValueForCellByDictinary:(NSDictionary *) dic;
@end
